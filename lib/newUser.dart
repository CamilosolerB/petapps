import 'package:adopt_me/autentication.dart';
import 'package:adopt_me/querys.dart';
import 'package:adopt_me/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:adopt_me/home.dart';

class NewUser extends StatefulWidget {
  const NewUser({super.key});

  @override
  State<NewUser> createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  void enviarFormulario(){
    final cedula = int.parse(cedulaController.text);
    final nombre = nombreController.text;
    final email = Authentication.correo;
    final phone = int.parse(telefonoController.text);
    final address = direccionController.text;   
    final bornDate = "${selectedDate.toLocal()}".split(' ')[0];
    final usuario = User(cedula: cedula, nombre: nombre, email: email, phone: phone, address: address, bornDate: bornDate);
    Petition().addUser(usuario);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Homepage()));
  }

  final nombreController = TextEditingController();
  final cedulaController = TextEditingController();
  final direccionController = TextEditingController();
  final telefonoController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1950, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Registro"),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontFamily: 'Sans-Serif',
          fontSize: 25,
        ),
      ),
      body:  Center(
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
                  iconColor: Colors.black
                  ),
                ),
                width: 250
              ),
              Container(
                child: TextFormField(
                  controller: cedulaController,
                  decoration: InputDecoration(
                  hintText: "Numero de documento",
                  labelText: "Numero de documento *",
                  icon: Icon(Icons.document_scanner),
                  iconColor: Colors.black
                  ),
                ),
                width: 250
              ),
              Container(
              child: TextFormField(
                controller: direccionController,
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
                  controller: telefonoController,
                  decoration: InputDecoration(
                  hintText: "Telefono",
                  labelText: "Telefono *",
                  icon: Icon(Icons.phone),
                  iconColor: Colors.black
                  ),
                ),
                width: 250
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("${selectedDate.toLocal()}".split(' ')[0]),
                  const SizedBox(height: 20.0,),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Fecha de nacimiento'),
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
                        border: Border.all(width: 2.0, color: Color(0xFF221FEB))
                    ),
                    child: Center(
                      child: Text("Registrarse", textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                ),
                onTap: (){
                  enviarFormulario();
                },
              )
            ])
          )
        )
      )
    );
  }
}