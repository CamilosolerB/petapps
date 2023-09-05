import 'package:adopt_me/autentication.dart';
import 'package:flutter/material.dart';
class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  final emailController = TextEditingController();
  Future<void> sendEmail() async{

  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Recuperar contraseña"),
        backgroundColor: Colors.indigo
      ),
      body: Center(
        child: SizedBox(
          height: height *0.3,
          width: width * 0.6,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Recuperar contraseña"),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                  hintText: "Correo electronico",
                  labelText: "Correo electronico *",
                  icon: Icon(Icons.account_circle_rounded),
                  iconColor: Colors.black
                  ),
            ),
            ElevatedButton(
              onPressed: (){
                Authentication().forgotPassword(emailController.text, context);
              }, 
              child: Text("Enviar correo de recuperacion"))
          ],
        ),
        )
      )
    );
  }
}
