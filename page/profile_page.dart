import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jp_lesson/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String url = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text('Profile'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 25),
          StreamBuilder(
              stream: firestore
                  .collection('Users')
                  .doc(firebaseAuth.currentUser!.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text('Connection error');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                var docs = snapshot.data!.data() as Map<String, dynamic>;
                return Column(
                  children: [
                    InkWell(
                      onTap: () => uploadImage(),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: docs['url'].toString().isEmpty
                            ? Image.network(
                                'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                                fit: BoxFit.cover,
                                width: 150,
                                height: 150)
                            : Image.network(docs['url'].toString(),
                                fit: BoxFit.cover, width: 150, height: 150),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(docs['name'].toString(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(docs['email'].toString(),
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 25),
                    SizedBox(
                        width: size.width * 0.9,
                        child: ElevatedButton(
                            onPressed: () {}, child: const Text('Edit')))
                  ],
                );
              }),
          const Divider(height: 50, thickness: 2),
          Column(
            children: [
              const ListTile(
                  leading: Icon(Icons.settings), title: Text('Settings')),
              const ListTile(leading: Icon(Icons.share), title: Text('Share')),
              const ListTile(
                  leading: Icon(Icons.person), title: Text('About Us')),
              InkWell(
                onTap: () => authController.logoutUser(),
                child: const ListTile(
                    leading: Icon(Icons.logout), title: Text('Logout')),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future uploadImage() async {
    // final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();

    Reference referenceDireImages = referenceRoot.child('images');

    Reference referenceImageToUpload = referenceDireImages.child(fileName);

    try {
      await referenceImageToUpload.putFile(File(file.path));
      url = await referenceImageToUpload.getDownloadURL();
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('error${error.toString()}')));
    }
    firestore.collection('Users').doc(firebaseAuth.currentUser!.email).update({
      'url': url,
    });
  }
}
