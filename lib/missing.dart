import 'package:adopt_me/pets.dart';
import 'package:adopt_me/querys.dart';
import 'package:adopt_me/slivers.dart';
import 'package:flutter/material.dart';

class Missing extends StatefulWidget {
  const Missing({super.key});

  @override
  State<Missing> createState() => _MissingState();
}

class _MissingState extends State<Missing> {
  List<Pets> listaMascotas = [];
  Future<void> getPets() async {
    try {
      final mascotas = await Petition().getPets("Disapear");
      setState(() {
        listaMascotas = mascotas;
      });
    } catch (error) {
      print('Error al obtener la lista de mascotas: $error');
      // Manejar el error de manera adecuada, por ejemplo, mostrando un mensaje al usuario.
    }
  }
    @override
  void initState() {
    super.initState();
    // Obtener la lista de mascotas una vez en initState.
    getPets();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Mascotas perdidas"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.indigo,
      ),
      body: Center(
      child: Column(
        children: [
          Text("Por favor ayúdanos a encontrarlos"),
          listaMascotas.isEmpty
              ? Text('No hay datos disponibles.')
              : Container(
                  height: height * 0.9,
                  width: width * 0.9,
                  child: SliverPets(pets: listaMascotas),
                ),
        ],
      ),
    )
    );
  }
}