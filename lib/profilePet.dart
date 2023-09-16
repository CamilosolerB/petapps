import 'dart:convert';
import 'dart:io';

import 'package:adopt_me/autentication.dart';
import 'package:adopt_me/events.dart';
import 'package:adopt_me/pets.dart';
import 'package:flutter/material.dart';
import 'package:adopt_me/querys.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ProfilePet extends StatefulWidget {
  final Pets pet;
  const ProfilePet({required this.pet});

  @override
  State<ProfilePet> createState() => _ProfilePetState();
}

class _ProfilePetState extends State<ProfilePet> {
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
  bool isEditMode = false;
  late TextEditingController nombreController;
  late TextEditingController edadController;
  late TextEditingController razaController;
  late TextEditingController addressController;
  late TextEditingController phoneController;
  late TextEditingController idController;
  late TextEditingController reviewController;
  String departamentController = "";
  String cityController = "";
  String urlController= "";
  String state = "";
  Future<void> stateFuture () async{
    state = await Petition().isState(widget.pet.id);
  }

  @override
  void initState(){
    super.initState();
    nombreController = TextEditingController(text: widget.pet.nombre);
    edadController = TextEditingController(text: widget.pet.edad.toString());
    razaController = TextEditingController(text: widget.pet.raza);
    addressController = TextEditingController(text: widget.pet.address);
    phoneController = TextEditingController(text: widget.pet.phone.toString());
    idController = TextEditingController(text: widget.pet.id);
    String departamentController = widget.pet.departament;
    String cityController = widget.pet.city;
    String urlController = widget.pet.url;
    stateFuture();
    print(state);
    getData();
  }

  @override
  void dispose() {
    nombreController.dispose();
    edadController.dispose();
    razaController.dispose();
    addressController.dispose();
    phoneController.dispose();
    idController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      isEditMode = !isEditMode;
    });
  }

  void _saveChanges() {
    if(urlController == ""){
      urlController = widget.pet.url;
    }
    final name = nombreController.text;
    final age = int.parse(edadController.text);
    final raza = razaController.text;
    final address = addressController.text;
    final phone = int.parse(phoneController.text);
    final departament = departamentController;
    final city = cityController;
    final url = urlController;
    final email = Authentication.correo;
    final id = idController.text;
    final pet = Pets(nombre: name, edad: age, raza: raza, address: address, phone: phone, departament: departament, city: city, url: url, email: email, id: id);
    Petition().updatePet(pet, 'Pets');
      setState(() {
        isEditMode = false;
      });
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

    void _launchWhatsApp() async {
    final phoneNumber = widget.pet.phone;
    final whatsappUrl = "https://wa.me/$phoneNumber";

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("WhatsApp is not installed on your device."),
        ),
      );
    }
  }

  void _launchPhoneDialer() async {
    final phoneNumber = widget.pet.phone.toString();
    final phoneUrl = "tel:$phoneNumber";

    if (await canLaunch(phoneUrl)) {
      await launch(phoneUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Could not launch the phone dialer."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet.nombre),
        foregroundColor: Colors.white,
        backgroundColor: Colors.indigo
      ),
      body: Column(
        children: [
          SizedBox(
            child: Column(
              children: [
                if (!isEditMode)
                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.pet.url),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                if (isEditMode)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: TextFormField(
                            controller: nombreController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Por favor, ingrese un nombre.';
                              }
                              return null;
                            },
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, ingrese un nombre.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Edad",
                      labelText: "Edad en años*",
                      icon: Icon(Icons.access_time_filled),
                      iconColor: Colors.black,
                    ),
                  ),
                  width: 250,
                ),
                Container(
                  child: TextFormField(
                    controller: razaController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, ingrese un nombre.';
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, ingrese un nombre.';
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, ingrese un nombre.';
                      }
                      return null;
                    },
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
                  label: Text("Cambiar foto"),
                ),   // Más campos de edición aquí...
                      ],
                    ),
                  ),
                if (!isEditMode)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nombre: ${widget.pet.nombre}'),
                        Text('Edad: ${widget.pet.edad} años'),
                        Text('Raza: ${widget.pet.raza}'),
                        Text('Dirección: ${widget.pet.address}'),
                        Text('Teléfono: ${widget.pet.phone.toString()}'),
                        Text('Departamento: ${widget.pet.departament}'),
                        Text('Ciudad: ${widget.pet.city}'),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: isEditMode
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _saveChanges();
                        },
                        child: Text('Guardar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isEditMode = false;
                          });
                        },
                        child: Text('Cancelar'),
                      ),
                    ],
                  )
                : widget.pet.email == Authentication.correo
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _toggleEdit();
                            },
                            child: Text('Editar'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Lógica para eliminar
                              // Confirmación
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Eliminar Mascota'),
                                    content: Text('¿Está seguro de que desea eliminar esta mascota?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Petition().deletePet(widget.pet.id);
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Su mascota ha sido retirada")));
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Eliminar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text('Eliminar'),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: (){
                              _launchWhatsApp();
                              Petition().beginAdopt(idController.text);
                            },
                            child: Text('Contact via WhatsApp'),
                          ),
                          ElevatedButton(
                            onPressed: (){
                              _launchPhoneDialer();
                              Petition().beginAdopt(idController.text);
                            },
                            child: Text('Contact via Phone'),
                          )
                        ],
                      ),
                      if(state.isNotEmpty)
                        ElevatedButton(
                        onPressed: () async {
                          final firstDialogResult = await showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text('¿Finalizar proceso?'),
                              content: Text('¿Estás seguro de finalizar el proceso de adopción?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'No'),
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'Si'),
                                  child: const Text('Si'),
                                ),
                              ],
                            ),
                          );

                          if (firstDialogResult == 'Si') {
                            if(cityController == "Mosquera"){
                              EventsFirebase().adoptMosquera();
                            }
                            EventsFirebase().percentAdopt();
                            final secondDialogResult = await showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text('Fin proceso'),
                                content: Text('¿La adopción se realizó?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, 'Si'),
                                    child: const Text('Si'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, 'No'),
                                    child: const Text('No'),
                                  ),
                                ],
                              ),
                            );

                            if (secondDialogResult == 'Si' || secondDialogResult == 'No') {
                              if(secondDialogResult == 'Si'){
                                Petition().deletePet(idController.text);
                              }
                              final reviewController = TextEditingController();
                              final feedbackResult = await showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text('Danos una retroalimentación'),
                                  content: TextField(
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    controller: reviewController,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, 'Enviar'),
                                      child: const Text('Enviar'),
                                    ),
                                  ],
                                ),
                              );

                              if (feedbackResult == 'Enviar') {
                                Petition().updateState(state, reviewController.text);
                              }
                            }
                          }
                        },
                        child: Text('Finalizar'),
                        )

                      ],
                      ),
          ),
        ],
      ),
    );
  }
}
