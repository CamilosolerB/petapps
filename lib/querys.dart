import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:adopt_me/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Petition{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<bool> checkIfEmailExist(String email) async{
    final QuerySnapshot snapshot = await firestore
        .collection('User')
        .where('email', isEqualTo: email)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  Future<void> addUser(User user){
    return firestore
      .collection('User')
      .add({
        'name' : user.nombre,
        'cedula' : user.cedula,
        'email' : user.email,
        'phone' : user.phone,
        'bornDate' : user.bornDate,
        'address' : user.address
      })
      .then((value) => print("añadido"))
      .catchError((error) => print("Error: " + error));
  }

  Future<void> loadPhoto(File? file, String filename) async {
    final ref = await FirebaseStorage.instance.ref().child('uploads/$filename');
    ref.putFile(file!);
  }
}
