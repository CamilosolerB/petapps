import 'package:cloud_firestore/cloud_firestore.dart';

class Petition{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<bool> checkIfEmailExist(String email) async{
    final QuerySnapshot snapshot = await firestore
        .collection('Users')
        .where('email', isEqualTo: email)
        .get();
    return snapshot.docs.isNotEmpty;
  }
}
