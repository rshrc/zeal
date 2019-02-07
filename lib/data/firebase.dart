import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'app_data.dart';
import 'user.dart';

Future<void> updateUserDB() async {
  if (UserData().fireUser != null) {
    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('id', isEqualTo: UserData().fireUser.uid)
        .getDocuments()
        .then((v) => v);
    final List<DocumentSnapshot> documents = result.documents;
    final currentUser = new User(
        uid: UserData().fireUser.uid,
        name: UserData().fireUser.displayName,
        profileImage: UserData().fireUser.photoUrl,
        email: UserData().fireUser.email,
        isAdmin: UserData().isAdmin,
        followers: Set(),
        following: Set(),
        bio: "");
    UserData().user = currentUser;
    if (documents.length == 0) {
      // Update data to server if new user
      Firestore.instance
          .collection('users')
          .document(UserData().user.uid)
          .setData({
        'name': UserData().user.name,
        'photoUrl': UserData().user.profileImage,
        'id': UserData().user.uid,
        'email': UserData().user.email,
        'isAdmin': UserData().user.isAdmin,
        'followers': List(),
        'following': List(),
        'hobbies': List(),
        'bio': ""
      });
    }
  }
}

Future<String> uploadImage(File imageFile) async {
  String _fileName =
      "${new Random().nextInt(10000)}_${new Random().nextInt(10000)}_${new Random().nextInt(10000)}.jpg";
  StorageReference ref =
      FirebaseStorage.instance.ref().child("${UserData().user.uid}/$_fileName");
  StorageUploadTask uploadTask = ref.putFile(imageFile);
  return await (await uploadTask.onComplete).ref.getDownloadURL();
}

Future<String> uploadImageAs(File imageFile, String name) async {
  String _fileName = name;
  StorageReference ref =
      FirebaseStorage.instance.ref().child("${UserData().user.uid}/$_fileName");
  StorageUploadTask uploadTask = ref.putFile(imageFile);
  return await (await uploadTask.onComplete).ref.getDownloadURL();
}

Future<File> getImage() async {
  print("Called getImage");
  return await ImagePicker.pickImage(source: ImageSource.gallery);
}

void createPost() {}
