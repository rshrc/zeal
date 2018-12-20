import 'package:cloud_firestore/cloud_firestore.dart';

import 'app_data.dart';

Future<void> updateUserDB() async {
  if (UserData().user != null) {
    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('id', isEqualTo: UserData().user.uid)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 0) {
      // Update data to server if new user
      Firestore.instance
          .collection('users')
          .document(UserData().user.uid)
          .setData({
        'name': UserData().user.displayName,
        'photoUrl': UserData().user.photoUrl,
        'id': UserData().user.uid
      });
    }
  }
}
