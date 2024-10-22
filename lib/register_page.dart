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

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerQuantity = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('shopping_list');

  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add an Item'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => navigateToPage(context, ProfilePage()),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildTextFormField(
                  _controllerName, 'Enter the name of the item', 'Please enter the item name'),
              const SizedBox(height: 20),
              buildTextFormField(
                  _controllerQuantity, 'Enter the quantity of the item', 'Please enter the item quantity'),
              const SizedBox(height: 30),
              buildElevatedButton(
                icon: Icons.camera_alt,
                label: 'Upload Image',
                onPressed: pickAndUploadImage,
              ),
              const SizedBox(height: 20),
              buildElevatedButton(
                icon: Icons.cloud_upload,
                label: 'Submit',
                onPressed: addItemToFirestore,
              ),
              const SizedBox(height: 20),
              buildElevatedButton(
                icon: Icons.payment,
                label: 'Make Payment',
                onPressed: () =>
                    Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentPage())),
              ),
              const SizedBox(height: 20),
              buildElevatedButton(
                icon: Icons.view_list,
                label: 'View User Data',
                onPressed: () =>
                    Navigator.push(context, MaterialPageRoute(builder: (_) => UserDataPage())),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildTextFormField(
      TextEditingController controller, String hintText, String validationMessage) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.purpleAccent, width: 2),
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

  ElevatedButton buildElevatedButton(
      {required IconData icon, required String label, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        primary: Colors.deepPurple,
        onPrimary: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }

  Future<void> pickAndUploadImage() async {
    if (kIsWeb) {
      uploadImageWeb();
    } else {
      final ImagePicker imagePicker = ImagePicker();
      final XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
      if (file == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('No image selected')));
        return;
      }

      String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}_${file.name}';
      Reference storageReference = FirebaseStorage.instance.ref().child(fileName);

      try {
        await storageReference.putFile(File(file.path));
        imageUrl = await storageReference.getDownloadURL();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Image uploaded successfully')));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to upload image: $e')));
      }
    }
  }

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
        imageUrl = await snapshot.ref.getDownloadURL();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Image uploaded successfully')));
      });
    });
  }

  Future<void> addItemToFirestore() async {
    if (imageUrl == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please upload an image')));
      return;
    }

    if (formKey.currentState!.validate()) {
      Map<String, String> dataToSend = {
        'name': _controllerName.text,
        'quantity': _controllerQuantity.text,
        'image': imageUrl!,
      };

      try {
        await _reference.add(dataToSend);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Item added successfully')));
        _controllerName.clear();
        _controllerQuantity.clear();
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to add item: $e')));
      }
    }
  }

  void navigateToPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.deepPurple,
      ),
      body: const Center(
        child: Text("Profile Details Here"),
      ),
    );
  }
}

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
                title: Text(data['name']),
                subtitle: Text(data['quantity']),
                trailing: data['image'] != null
                    ? Image.network(data['image'], width: 100, fit: BoxFit.cover)
                    : null,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
