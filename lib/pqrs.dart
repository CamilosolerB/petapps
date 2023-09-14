import 'dart:convert';

import 'package:adopt_me/autentication.dart';
import 'package:adopt_me/querys.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Pqrs extends StatefulWidget {
  const Pqrs({super.key});

  @override
  State<Pqrs> createState() => _PqrsState();
}

class _PqrsState extends State<Pqrs> {
  String? name = "";
  Future<void> checkName() async {
    String? name = await Petition().checkName();
  }
  Future sendEmail({
    required String name,
    required String email,
    required String subject,
    required String message,
  })async{
    final serviceId = 'service_j0jkq1p';
    final templateId = 'template_fr6baph';
    final userId = 'wPU69yJ5b2BGSxo7E';


    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    final response  = await http.post(
      url,
      headers: {
        'origin' : 'http://localhost',
        'Content-Type':'application/json',
      },
      body: json.encode({
        'service_id':serviceId,
        'template_id':templateId,
        'user_id':userId,
        'template_params':{
          'user_name': name,
          'user_email': email,
          'user_message': message,
          'user_subject': subject,
        }
      })
      );
  }

  final titleController = TextEditingController();
  final messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          title: Text("Peticiones, quejas, reclamos")
        ),
        body: Center(
          child: SizedBox(
            width: width * 0.8,
            height: height *0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Titulo de la solicitud"),
              TextFormField(
                controller: titleController,
                  decoration: InputDecoration(
                  hintText: "Nombre",
                  labelText: "Nombre *",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo)
                  )
                  ),
              ),
              Text("Especifica tu caso"),
              TextField(
                controller: messageController,
                maxLines: 15,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "Enter your text here",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo)
                  )
                ),
              ),
              ElevatedButton(onPressed: (){
                sendEmail(name: name!, email: Authentication.correo, subject: titleController.text, message: messageController.text);
              }, child: Text("Enviar PQR"))
            ]
          ),
          )
        )
    );
  }
}