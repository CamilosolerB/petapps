import 'package:flutter/material.dart';

class Pqrs extends StatefulWidget {
  const Pqrs({super.key});

  @override
  State<Pqrs> createState() => _PqrsState();
}

class _PqrsState extends State<Pqrs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text("Peticiones, quejas, reclamos")
        ),
        body: Center(
          child: Column(
            children: [
              
            ]
          )
        )
    );
  }
}