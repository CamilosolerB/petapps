import 'package:adopt_me/autentication.dart';
import 'package:adopt_me/home.dart';
import 'package:adopt_me/login.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Authentication().authStateChanges,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return const Homepage();
          }
          else{
            return const Login();
          }
        });
  }
}
