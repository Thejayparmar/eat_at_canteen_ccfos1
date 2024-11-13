import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:html' as html;
import 'firebase_options.dart';
import 'package:eat_at_canteen_ccfos/PaymentPage.dart';
import 'package:eat_at_canteen_ccfos/user_data_page.dart';

// Stateful widget for adding an item
class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final TextEditingController _controllerName = TextEditingController();  // Controller for item name input
  final TextEditingController _controllerQuantity = TextEditingController();  // Controller for quantity input
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();  // Form key to validate form

  final CollectionReference _reference = FirebaseFirestore.instance.collection('shopping_list');  // Firestore reference for shopping list

  String? imageUrl;  // To store the URL of the uploaded image

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add an Item'),  // Title of the screen
        backgroundColor: Colors.deepPurple,  // AppBar color
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => navigateToPage(context, ProfilePage()),  // Navigate to Profile Page
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,  // Use the formKey to validate the form
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildTextFormField(
                  _controllerName, 'Enter the name of the item', 'Please enter the item name'),  // TextFormField for item name
              const SizedBox(height: 20),
              buildTextFormField(
                  _controllerQuantity, 'Enter the quantity of the item', 'Please enter the item quantity'),  // TextFormField for item quantity
              const SizedBox(height: 30),
              buildElevatedButton(
                icon: Icons.camera_alt,
                label: 'Upload Image',
                onPressed: pickAndUploadImage,  // Function to pick and upload an image
              ),
              const SizedBox(height: 20),
              buildElevatedButton(
                icon: Icons.cloud_upload,
                label: 'Submit',
                onPressed: addItemToFirestore,  // Function to add item to Firestore
              ),
              const SizedBox(height: 20),
              buildElevatedButton(
                icon: Icons.payment,
                label: 'Make Payment',
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentPage())),  // Navigate to PaymentPage
              ),
              const SizedBox(height: 20),
              buildElevatedButton(
                icon: Icons.view_list,
                label: 'View User Data',
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UserDataPage())),  // Navigate to UserDataPage
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build a TextFormField widget with custom properties
  TextFormField buildTextFormField(
      TextEditingController controller, String hintText, String validationMessage) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,  // Hint text to show inside the TextFormField
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),  // Border radius for rounded corners
          borderSide: const BorderSide(color: Colors.deepPurple),  // Border color
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),  // Focused border styling
          borderSide: const BorderSide(color: Colors.purpleAccent, width: 2),  // Focused border color and width
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationMessage;  // Return validation message if field is empty
        }
        return null;  // Return null if field is valid
      },
    );
  }

  // Method to build an ElevatedButton widget with icon and label
  ElevatedButton buildElevatedButton(
      {required IconData icon, required String label, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,  // Function to be called on button press
      icon: Icon(icon),  // Icon for the button
      label: Text(label),  // Label for the button
      style: ElevatedButton.styleFrom(
        primary: Colors.deepPurple,  // Button color
        onPrimary: Colors.white,  // Text color
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),  // Button padding
      ),
    );
  }

  // Method to pick and upload image based on platform
  Future<void> pickAndUploadImage() async {
    if (kIsWeb) {
      uploadImageWeb();  // If the app is running on the web, use web-specific upload method
    } else {
      final ImagePicker imagePicker = ImagePicker();  // Use image_picker for mobile devices
      final XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
      if (file == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('No image selected')));
        return;
      }

      String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}_${file.name}';  // Create a unique filename
      Reference storageReference = FirebaseStorage.instance.ref().child(fileName);  // Firebase Storage reference

      try {
        await storageReference.putFile(File(file.path));  // Upload the image
        imageUrl = await storageReference.getDownloadURL();  // Get the URL of the uploaded image
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Image uploaded successfully')));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to upload image: $e')));
      }
    }
  }

  // Method to upload image on web using Firebase Storage
  void uploadImageWeb() {
    final input = html.FileUploadInputElement();
    input.accept = 'image/*';  // Accept image files only
    input.click();
    input.onChange.listen((event) {
      final file = input.files!.first;
      final reader = html.FileReader();
      reader.readAsDataUrl(file);  // Read the file as a data URL
      reader.onLoadEnd.listen((event) async {
        var snapshot = await FirebaseStorage.instance
            .ref('images/${DateTime.now().millisecondsSinceEpoch}_${file.name}')
            .putBlob(file);  // Upload the image blob
        imageUrl = await snapshot.ref.getDownloadURL();  // Get the download URL of the uploaded image
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Image uploaded successfully')));
      });
    });
  }

  // Method to add item to Firestore
  Future<void> addItemToFirestore() async {
    if (imageUrl == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please upload an image')));
      return;
    }

    if (formKey.currentState!.validate()) {
      Map<String, String> dataToSend = {
        'name': _controllerName.text,  // Get the name of the item
        'quantity': _controllerQuantity.text,  // Get the quantity of the item
        'image': imageUrl!,  // Store the image URL
      };

      try {
        await _reference.add(dataToSend);  // Add item data to Firestore
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Item added successfully')));
        _controllerName.clear();  // Clear the name field
        _controllerQuantity.clear();  // Clear the quantity field
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to add item: $e')));
      }
    }
  }

  // Method to navigate to another page
  void navigateToPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}

// ProfilePage widget for displaying user profile
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.deepPurple,
      ),
      body: const Center(
        child: Text("Profile Details Here"),  // Placeholder for profile details
      ),
    );
  }
}

// UserDataPage widget to display items from Firestore
class UserDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Data"),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('shopping_list').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['name']),  // Display the item name
                subtitle: Text(data['quantity']),  // Display the item quantity
                trailing: data['image'] != null
                    ? Image.network(data['image'], width: 100, fit: BoxFit.cover)  // Display the item image if available
                    : null,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
