import 'dart:convert';
import 'dart:io';
import 'package:adopt_me/querys.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class FormPets extends StatefulWidget {
  const FormPets({Key? key});

  @override
  State<FormPets> createState() => _FormPetsState();
}

class _FormPetsState extends State<FormPets> {
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
    }
  }

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
        title: Text("Registro de adopción de mascota"),
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
                  onTap: () {},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:adopt_me/querys.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class FormPets extends StatefulWidget {
  const FormPets({super.key});

  @override
  State<FormPets> createState() => _FormPetsState();
}

class _FormPetsState extends State<FormPets> {
  Future<void> getFile() async{
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false
    );
    if(fileResult != null){
      PlatformFile? picketFile = fileResult.files.first;
      String fileName = fileResult.files.first.name;
      File? file = File(picketFile.path!);
      Petition().loadPhoto(file, fileName);
    }
  }
  List data = [];
  int _valueDepartamento = 1;
  String _valueMunicipio= "";
  List<String> _municipios = [];
  getData()async{
    String url  = "https://raw.githubusercontent.com/marcovega/colombia-json/master/colombia.min.json";
    final response = await http.get(Uri.parse(url));
    data = jsonDecode(response.body);
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Registro de adopcion de mascota"),
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
                  decoration: InputDecoration(
                  hintText: "Nombre",
                  labelText: "Nombre *",
                  icon: Icon(Icons.account_circle_rounded),
                  iconColor: Colors.black
                  ),
                ),
                width: 250
              ),
              Container(
                child: TextFormField(
                  decoration: InputDecoration(
                  hintText: "Edad",
                  labelText: "Edad *",
                  icon: Icon(Icons.access_time_filled),
                  iconColor: Colors.black
                  ),
                ),
                width: 250
              ),
              Container(
                child: TextFormField(
                  decoration: InputDecoration(
                  hintText: "Raza",
                  labelText: "Raza *",
                  icon: Icon(Icons.pets),
                  iconColor: Colors.black
                  ),
                ),
                width: 250
              ),
              Container(
              child: TextFormField(
                decoration: InputDecoration(
                hintText: "Direccion",
                labelText: "Direccion *",
                icon: Icon(Icons.home_outlined),
                iconColor: Colors.black
                ),
              ),
              width: 250
              ),
              Container(
                child: TextFormField(
                  decoration: InputDecoration(
                  hintText: "Telefono contacto",
                  labelText: "Telefono *",
                  icon: Icon(Icons.phone),
                  iconColor: Colors.black
                  ),
                ),
                width: 250
              ),
              Column(
                children: [
                    Text("Departamento"),
                    DropdownButton(
                      value: _valueDepartamento,
                      items: data.map((e) {
                        return DropdownMenuItem(child: Text(e["departamento"]), value: e["id"],);
                      }).toList(), 
                      onChanged: (v) {
                        setState(() {
                          _valueDepartamento = v as int; // Actualiza la variable del departamento
                          _municipios = List<String>.from(data[v]["ciudades"]);
                          _valueMunicipio = _municipios[0];
                        });
                      }
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
                        });
                      }
                    )
                  ],

              ),
              ElevatedButton.icon(
                icon: Icon(Icons.add_a_photo),
                onPressed: (){
                try{
                  getFile();
                }catch(e){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hubo un error al subir la imagen intente mas tarde")));
                } 
              }, label: Text("Subir foto")),
              InkWell(
                child: Container(
                    width: 250,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Color(0xFF221FEB),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 2.0, color: Color(0xFF221FEB))
                    ),
                    child: Center(
                      child: Text("Dar en adopcion", textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                ),
                onTap: (){
                },
              )
            ])
          )
        )
      ),
    );
  }
}
*/