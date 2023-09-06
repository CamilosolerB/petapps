import 'package:flutter/material.dart';

class Pqrs extends StatefulWidget {
  const Pqrs({super.key});

  @override
  State<Pqrs> createState() => _PqrsState();
}

class _PqrsState extends State<Pqrs> {

  final titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
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
                maxLines: 15,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "Enter your text here",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo)
                  )
                ),
              ),
              ElevatedButton(onPressed: (){}, child: Text("Enviar PQR"))
            ]
          ),
          )
        )
    );
  }
}