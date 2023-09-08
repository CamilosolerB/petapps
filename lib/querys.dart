import 'dart:io';
import 'dart:typed_data';
import 'package:adopt_me/autentication.dart';
import 'package:adopt_me/pets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:adopt_me/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Petition{
  int count = 0;
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
  Future<String?> checkName() async {
    try{
      CollectionReference user = firestore.collection('User');
      QuerySnapshot querySnapshot = await user.where('email', isEqualTo: Authentication.correo).get();
      if (querySnapshot.docs.isNotEmpty) {
        var nombre = querySnapshot.docs.first['name'];
        return nombre.toString();
      } else {
        return null;
      }
    }catch(e){
      print("Error al consultar Firestore: $e");
      return null;
    }
  }

  Future<List<Pets>> getPets(String collection) async{
    List<Pets> petsList =  [];
    QuerySnapshot pets = await firestore.collection(collection).get();
    try{
      for(QueryDocumentSnapshot document in pets.docs){
          String nombre = document['name'];
          int edad = document['age'];
          String raza = document['raza'];
          String address = document['address'];
          int phone = document['phone'];
          String departament = document['department'];
          String city = document['city'];
          String url = document['url'];
          String email = document['email'];
          DocumentSnapshot snapshot = pets.docs[count];
          String id = snapshot.id;
          Pets pet = Pets(nombre: nombre, edad: edad, raza: raza, address: address, phone: phone, departament: departament, city: city, url: url, email: email, id: id);
          petsList.add(pet);
          count++;
      }
      count = 0;
      return petsList;
    }catch(e){
      print('Error al obtener las mascotas: $e');
    return [];
    }
  }
    Future<List<Pets>> getPetsbyEmail(String collection) async{
    List<Pets> petsList =  [];

    QuerySnapshot pets = await firestore.collection(collection).where('email',isEqualTo: Authentication.correo).get();
    try{
      for(QueryDocumentSnapshot document in pets.docs){
          String nombre = document['name'];
          int edad = document['age'];
          String raza = document['raza'];
          String address = document['address'];
          int phone = document['phone'];
          String departament = document['department'];
          String city = document['city'];
          String url = document['url'];
          String email = document['email'];
          DocumentSnapshot snapshot = pets.docs[count];
          String id = snapshot.id;
          Pets pet = Pets(nombre: nombre, edad: edad, raza: raza, address: address, phone: phone, departament: departament, city: city, url: url, email: email, id: id);
          petsList.add(pet);
          count++;
      }
      count = 0;
      return petsList;
    }catch(e){
      print('Error al obtener las mascotas: $e');
    return [];
    }
  }

  Future <void> getUserId() async {
    DocumentReference ref = firestore.collection('users').doc();
    print(ref);
  }

  Future<void> addPet(Pets pet, String collection){
    bool check = false;
    return firestore
    .collection(collection)
    .add({
      'name' : pet.nombre,
      'age' : pet.edad,
      'raza' : pet.raza,
      'address' : pet.address,
      'phone' : pet.phone,
      'department' : pet.departament,
      'city' : pet.city,
      'url' : pet.url,
      'email' : pet.email
    })
    .then((value) => print("exitoso"))
    .catchError((error)=> print("Error: " + error));
  }
  Future<void> deletePet(String id) async{
    DocumentReference documentReference = firestore.collection('Pets').doc(id);
    documentReference.delete()
    .then((_) {
      print("Documento eliminado con éxito");
    })
    .catchError((error) {
      print("Error al eliminar el documento: $error");
    });
  }
  Future<void> updatePet(Pets pet, String collection) async{
    String id = pet.id;
    Map<String, dynamic> updateData = {
      'name' : pet.nombre,
      'age' : pet.edad,
      'raza' : pet.raza,
      'address' : pet.address,
      'phone' : pet.phone,
      'department' : pet.departament,
      'city' : pet.city,
      'url' : pet.url,
      'email' : pet.email
    };
    try{
      await firestore.collection(collection).doc(id).update(updateData);
    }catch(e){
      print('Error updating document: $e');
    }
  }
}
