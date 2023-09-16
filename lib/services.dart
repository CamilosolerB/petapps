import 'package:adopt_me/formPets.dart';
import 'package:adopt_me/pets.dart';
import 'package:adopt_me/querys.dart';
import 'package:adopt_me/slivers.dart';
import 'package:flutter/material.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  List<Pets> listaMascotas = [];
  List<Pets> disapear = [];
  @override
  void initState() {
    super.initState();
    // Obtener la lista de mascotas una vez en initState.
    getPets();
  }
    Future<void> getPets() async {
    try {
      final mascotas = await Petition().getPetsbyEmail('Pets');
      final perdidas = await Petition().getPetsbyEmail('Disapear');
      setState(() {
        listaMascotas = mascotas;
        disapear = perdidas;
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
          Container(
            height: height *0.4,
            child: Column(
              children: [
                Text("En Proceso de Adopcion",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Sans-serif',
                ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FormPets(title: "Formulario registro mascotas",collection: 'Pets',)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent,
                    onPrimary: Colors.white
                  ),
                  child: Text("Dar en Adopcion"),
                ),
                listaMascotas.isEmpty
                ? Text('No hay datos disponibles.')
                : Container(
                    height: height * 0.2,
                    width: width * 0.9,
                    child: SliverPets(pets: listaMascotas),
                  ),
              ],
            ),
          ),
          
          Divider(
            color: Colors.indigo,
          ),
          Container(
            child: Column(
              children: [
                Text("En busqueda de mis mascotas",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Sans-serif',
                )),
                ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FormPets(title: "Formulario busqueda mascotas", collection: 'Disapear',)),
              );
            },
            style: ElevatedButton.styleFrom(
                    primary: Colors.purple,
                    onPrimary: Colors.white
                  ),
            child: Text("Reportar mascota"),
          ),
          disapear.isEmpty
                ? Text('No hay datos disponibles.')
                : Container(
                    height: height * 0.2,
                    width: width * 0.9,
                    child: SliverPets(pets: disapear),
                  ),
              ],
            ),
          )
        ]
        ),
    );
  }
}