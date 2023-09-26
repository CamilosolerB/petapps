import 'package:adopt_me/analitycs_services.dart';
import 'package:adopt_me/formPets.dart';
import 'package:adopt_me/pets.dart';
import 'package:adopt_me/profilePet.dart';
import 'package:adopt_me/querys.dart';
import 'package:adopt_me/slivers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final storage = FirebaseStorage.instance;
  List<Pets> listaMascotas = [];
  @override
  void initState() {
    super.initState();
    // Obtener la lista de mascotas una vez en initState.
    getPets();
  }

  Future<void> getPets() async {
    try {
      final mascotas = await Petition().getPets('Pets');
      setState(() {
        listaMascotas = mascotas;
      });
    } catch (error) {
      print('Error al obtener la lista de mascotas: $error');
      // Manejar el error de manera adecuada, por ejemplo, mostrando un mensaje al usuario.
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Center(
      child: Column(
        children: [
          listaMascotas.isEmpty
              ? Text('No hay datos disponibles.')
              : Container(
                  height: height * 0.73,
                  width: width * 0.9,
                  child: SliverPets(pets: listaMascotas),
                ),
        ],
      ),
    );
  }
}
