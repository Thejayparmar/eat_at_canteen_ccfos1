// Import necessary packages
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:html' as html; // For web image upload support

import '../PaymentPage.dart'; // Make sure the path is correct for PaymentPage
import '../user_data_page.dart'; // Make sure the path is correct for UserDataPage

// Main widget for adding an item
class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  // Controllers to manage input text for item name and quantity
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerAge = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>(); // Form key for validation

  // Firebase Firestore collection reference
  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('shopping_list');

  String? imageUrl; // Variable to hold image URL after upload

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add an Item'),
        backgroundColor: Colors.deepPurple,
        actions: [
          // Navigation to Profile page on icon tap
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () => navigateToPage(context, ProfilePage()),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.deepPurple, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Form(
          key: formKey, // Form key for validation
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text field for item name input
              buildTextFormField(_controllerName, 'Enter the name of the item', 'Please enter the item name'),
              SizedBox(height: 20),
              // Text field for item quantity input
              buildTextFormField(_controllerAge, 'Enter the quantity of the item', 'Please enter the item quantity'),
              SizedBox(height: 30),
              // Button to pick and upload image
              buildElevatedButton(Icons.camera_alt, 'Upload Image', pickAndUploadImage),
              SizedBox(height: 20),
              // Button to submit item to Firestore
              buildElevatedButton(Icons.cloud_upload, 'Submit', addItemToFirestore),
              SizedBox(height: 20),
              // Button to navigate to Payment page
              buildElevatedButton(Icons.payment, 'Make Payment', () => Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentPage()))),
              SizedBox(height: 20),
              // Button to view user data
              buildElevatedButton(Icons.view_list, 'View User Data', () => Navigator.push(context, MaterialPageRoute(builder: (_) => UserDataPage()))),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to create a styled text input field
  TextFormField buildTextFormField(TextEditingController controller, String hintText, String validationMessage) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.purpleAccent, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationMessage;
        }
        return null;
      },
    );
  }

  // Helper function to create a styled button with an icon
  ElevatedButton buildElevatedButton(IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        primary: Colors.deepPurple,
        onPrimary: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }

  // Function to pick and upload image (supports web and mobile)
  Future<void> pickAndUploadImage() async {
    if (kIsWeb) {
      uploadImageWeb();
    } else {
      // For mobile: use image picker
      final ImagePicker imagePicker = ImagePicker();
      final XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
      if (file == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No image selected')));
        return;
      }

      String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}_${file.name}';
      Reference storageReference = FirebaseStorage.instance.ref().child(fileName);

      try {
        await storageReference.putFile(File(file.path)); // Upload file
        imageUrl = await storageReference.getDownloadURL(); // Retrieve download URL
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image uploaded successfully')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to upload image: $e')));
      }
    }
  }

  // Web-specific function to upload an image
  void uploadImageWeb() {
    final input = html.FileUploadInputElement();
    input.accept = 'image/*';
    input.click();
    input.onChange.listen((event) {
      final file = input.files!.first;
      final reader = html.FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) async {
        var snapshot = await FirebaseStorage.instance
            .ref('images/${DateTime.now().millisecondsSinceEpoch}_${file.name}')
            .putBlob(file);
        imageUrl = await snapshot.ref.getDownloadURL(); // Retrieve download URL
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image uploaded successfully')));
      });
    });
  }

  // Function to add an item to Firestore
  Future<void> addItemToFirestore() async {
    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please upload an image')));
      return;
    }

    if (formKey.currentState!.validate()) {
      // Prepare data to send to Firestore
      Map<String, String> dataToSend = {
        'name': _controllerName.text,
        'quantity': _controllerAge.text,
        'image': imageUrl!,
      };

      try {
        await _reference.add(dataToSend); // Add data to Firestore
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item added successfully')));
        _controllerName.clear(); // Clear inputs after submission
        _controllerAge.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add item: $e')));
      }
    }
  }

  // Navigation function to move to another page
  void navigateToPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}

// Simple Profile Page
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Text("Profile Details Here"),
      ),
    );
  }
}

// User Data Page to display data from Firestore
class UserDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Data"),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('shopping_list').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // Display each item as a ListTile
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['name']),
                subtitle: Text(data['quantity']),
                trailing: data['image'] != null ? Image.network(data['image'], width: 100, fit: BoxFit.cover) : null,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
