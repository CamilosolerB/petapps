import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:adopt_me/autentication.dart';
import 'package:adopt_me/pets.dart';
import 'package:adopt_me/querys.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class FormPets extends StatefulWidget {
  final title;
  final collection;
  const FormPets({required this.title, required this.collection});

  @override
  State<FormPets> createState() => _FormPetsState();
}

class _FormPetsState extends State<FormPets> {
      void succestoast(){
      Fluttertoast.showToast(
        msg: "Su mascota ya se encuentra publica para adopcion",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM
      );
    }

    //controllers
  final nombreController = TextEditingController();
  final edadController = TextEditingController();
  final razaController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  String departamentController = "";
  String cityController = "";
  String urlController = "";

  Future<void> postPet() async {
    final name = nombreController.text;
    final age = int.parse(edadController.text);
    final raza = razaController.text;
    final address = addressController.text;
    final phone = int.parse(phoneController.text);
    final departament = departamentController;
    final city = cityController;
    final url = urlController;
    final email = Authentication.correo;
    final pet = Pets(nombre: name, edad: age, raza: raza, address: address, phone: phone, departament: departament, city: city, url: url, email: email, id: '');
    Petition().addPet(pet,widget.collection);
    succestoast();
  }

  Future<void> getFile() async {
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (fileResult != null) {
      PlatformFile? pickedFile = fileResult.files.first;
      String fileName = fileResult.files.first.name;
      File? file = File(pickedFile.path!);
      Petition().loadPhoto(file, fileName);
      urlController = 'https://firebasestorage.googleapis.com/v0/b/adoppet-98cf3.appspot.com/o/uploads%2F$fileName?alt=media';
    }
  }
  //declare the variables
  List data = [];
  int _valueDepartamento = 1;
  String _valueMunicipio = "";
  List<String> _municipios = [];

  Future<void> getData() async {
    String url = "https://raw.githubusercontent.com/marcovega/colombia-json/master/colombia.min.json";
    final response = await http.get(Uri.parse(url));
    data = jsonDecode(response.body);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(widget.title),
        titleTextStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Container(
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: TextFormField(
                    controller: nombreController,
                    decoration: InputDecoration(
                      hintText: "Nombre",
                      labelText: "Nombre *",
                      icon: Icon(Icons.account_circle_rounded),
                      iconColor: Colors.black,
                    ),
                  ),
                  width: 250,
                ),
                Container(
                  child: TextFormField(
                    controller: edadController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Edad",
                      labelText: "Edad *",
                      icon: Icon(Icons.access_time_filled),
                      iconColor: Colors.black,
                    ),
                  ),
                  width: 250,
                ),
                Container(
                  child: TextFormField(
                    controller: razaController,
                    decoration: InputDecoration(
                      hintText: "Raza",
                      labelText: "Raza *",
                      icon: Icon(Icons.pets),
                      iconColor: Colors.black,
                    ),
                  ),
                  width: 250,
                ),
                Container(
                  child: TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                      hintText: "Dirección",
                      labelText: "Dirección *",
                      icon: Icon(Icons.home_outlined),
                      iconColor: Colors.black,
                    ),
                  ),
                  width: 250,
                ),
                Container(
                  child: TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Teléfono contacto",
                      labelText: "Teléfono *",
                      icon: Icon(Icons.phone),
                      iconColor: Colors.black,
                    ),
                  ),
                  width: 250,
                ),
                Column(
                  children: [
                    Text("Departamento"),
                    DropdownButton(
                      value: _valueDepartamento,
                      items: data.map((e) {
                        return DropdownMenuItem(child: Text(e["departamento"]), value: e["id"]);
                      }).toList(),
                      onChanged: (v) {
                        setState(() {
                          _valueDepartamento = v as int;
                          departamentController = data[_valueDepartamento]["departamento"];
                          _municipios = List<String>.from(data[v]["ciudades"]);
                          _valueMunicipio = _municipios[0];
                        });
                      },
                    ),
                    Text("Municipio"),
                    DropdownButton(
                      value: _valueMunicipio,
                      items: _municipios.map((municipio) {
                        return DropdownMenuItem(child: Text(municipio), value: municipio);
                      }).toList(),
                      onChanged: (v) {
                        setState(() {
                          _valueMunicipio = v!;
                          cityController = _valueMunicipio;
                        });
                      },
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.add_a_photo),
                  onPressed: () {
                    try {
                      getFile();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Hubo un error al subir la imagen, inténtalo de nuevo más tarde"),
                      ));
                    }
                  },
                  label: Text("Subir foto"),
                ),
                InkWell(
                  child: Container(
                    width: 250,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(0xFF221FEB),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2.0, color: Color(0xFF221FEB)),
                    ),
                    child: Center(
                      child: Text(
                        "Dar en adopción",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    postPet();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
