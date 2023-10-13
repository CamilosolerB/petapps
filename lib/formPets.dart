import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:adopt_me/analitycs_services.dart';
import 'package:adopt_me/autentication.dart';
import 'package:adopt_me/pets.dart';
import 'package:adopt_me/querys.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class FormPets extends StatefulWidget {
  final title;
  final message;
  final collection;
  const FormPets(
      {required this.title, required this.collection, required this.message});

  @override
  State<FormPets> createState() => _FormPetsState();
}

class _FormPetsState extends State<FormPets> {
  void succestoast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  //controllers
  final nombreController = TextEditingController();
  final edadController = TextEditingController();
  final razaController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final motivoController = TextEditingController();
  String saludController = "";
  String departamentController = "";
  String cityController = "";
  String urlController = "";
  String tipoFecha = "";
  String tipoMascotaController = "";
  bool isPicture = false;

  Future<void> postPet() async {
    if (!isPicture) {
      succestoast("Por favor inserte una imagen de la mascota");
    } else {
      final name = nombreController.text;
      final age = int.parse(edadController.text);
      final fecha = tipoFecha;
      final raza = razaController.text;
      final address = addressController.text;
      final phone = int.parse(phoneController.text);
      final departament = departamentController;
      final city = cityController;
      final url = urlController;
      final tipoMascota = tipoMascotaController;
      final email = Authentication.correo;
      final motivo = motivoController.text;
      final salud = saludController;
      final pet = Pets(
          tipoMascota: tipoMascota,
          nombre: name,
          edad: age,
          tipoEdad: fecha,
          raza: raza,
          address: address,
          phone: phone,
          departament: departament,
          city: city,
          url: url,
          email: email,
          motivo: motivo,
          salud: salud,
          id: '');
      Petition().addPet(pet, widget.collection);
      succestoast("Registro completado");
    }
  }

  Future<bool> getFile() async {
    bool picture = false;
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (fileResult != null) {
      PlatformFile? pickedFile = fileResult.files.first;
      String fileName = fileResult.files.first.name;
      File? file = File(pickedFile.path!);
      Petition().loadPhoto(file, fileName);
      urlController =
          'https://firebasestorage.googleapis.com/v0/b/adoppet-98cf3.appspot.com/o/uploads%2F$fileName?alt=media';
      picture = true;
    }
    return picture;
  }

  //declare the variables
  List data = [];
  int _valueDepartamento = 1;
  String _valueMunicipio = "";
  List<String> _municipios = [];

  Future<void> getData() async {
    String url =
        "https://raw.githubusercontent.com/marcovega/colombia-json/master/colombia.min.json";
    final response = await http.get(Uri.parse(url));
    data = jsonDecode(response.body);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    tipoFecha = 'Años';
    tipoMascotaController = 'Gato';
    saludController = "Ninguna";
    getData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(widget.title),
        titleTextStyle: TextStyle(
          color: Colors.white,
        ),
        actions: [
          IconButton(
              onPressed: () async {
                try {
                  isPicture = await getFile();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Hubo un error al subir la imagen, inténtalo de nuevo más tarde"),
                  ));
                }
              },
              icon: Icon(
                Icons.add_a_photo,
                color: Colors.white,
              ))
        ],
      ),
      body: Center(
        child: Container(
          child: Form(
              child: SingleChildScrollView(
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
                SizedBox(
                  child: Row(children: [
                    Container(
                      padding: EdgeInsets.only(left: 50),
                      width: width * 0.6,
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
                    ),
                    Container(
                      child: DropdownButton<String>(
                        value: tipoFecha,
                        items: <String>['Años', 'Meses', 'Dias']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (v) {
                          setState(() {
                            tipoFecha = v!;
                          });
                        },
                      ),
                    )
                  ]),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text("Tipo de mascota", style: TextStyle(
                      fontSize: 20
                    ),),
                Container(
                  width: width *0.6,
                  height: height * 0.05,
                  child: DropdownButton<String>(
                    value: tipoMascotaController,
                    items: <String>["Perro", "Gato", "Ave", "Pez", "Roedor"]
                        .map((String valor) {
                      return DropdownMenuItem<String>(
                          value: valor, child: Text(valor));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        tipoMascotaController = value!;
                      });
                    },
                  ),
                )
                  ],
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
                !AnalyticsServices.isDisapear
                    ? Container(
                        child: TextField(
                          controller: motivoController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: "Motivo de adopcion",
                            labelText: "Motivo *",
                            icon: Icon(Icons.question_answer),
                            iconColor: Colors.black,
                          ),
                        ),
                        width: 250,
                      )
                    : Text(""),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text("Enfermedad principal", style: TextStyle(
                      fontSize: 20
                    ),),
                Container(
                  width: width *0.6,
                  height: height * 0.05,
                  child: DropdownButton<String>(
                    value: saludController,
                    items: <String>["Ninguna","Fisica", "Psicologica", "Degenerativa", "Respiratoria", "Cardilogica","Hormonal"]
                        .map((String valor) {
                      return DropdownMenuItem<String>(
                          value: valor, child: Text(valor));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        saludController = value!;
                      });
                    },
                  ),
                )
                  ],
                ),
                Column(
                  children: [
                    Text("Departamento"),
                    DropdownButton(
                      value: _valueDepartamento,
                      items: data.map((e) {
                        return DropdownMenuItem(
                            child: Text(e["departamento"]), value: e["id"]);
                      }).toList(),
                      onChanged: (v) {
                        setState(() {
                          _valueDepartamento = v as int;
                          departamentController =
                              data[_valueDepartamento]["departamento"];
                          _municipios = List<String>.from(data[v]["ciudades"]);
                          _valueMunicipio = _municipios[0];
                        });
                      },
                    ),
                    Text("Municipio"),
                    DropdownButton(
                      value: _valueMunicipio,
                      items: _municipios.map((municipio) {
                        return DropdownMenuItem(
                            child: Text(municipio), value: municipio);
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
                        "Subir",
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
          )),
        ),
      ),
    );
  }
}
