import 'package:adopt_me/autentication.dart';
import 'package:adopt_me/hamburguesa.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adoptar"),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      drawer: const Hamburguer(),
    );
  }
}
