import 'package:adopt_me/newUser.dart';
import 'package:flutter/material.dart';
import 'package:adopt_me/autentication.dart';
import 'package:adopt_me/forgot.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
  String? errorMessage = "";
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> checkEmailAndPassword() async{
    try {
      await Authentication().checkEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
          context: context
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage!)));
      });
    }
  }

  Future<void> singUpAndSingInWithGoogle() async {
    try{
      await Authentication().singUpAndSingInWithGoogle(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> singInWithFacebook() async{
    await Authentication().singInWithFacebook(context);
  }



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset('img/pets.svg',
            height: height * 0.15,
            width: width,
          ),
          Column(
              children: [
                const Text("APP PETS",
                  style: TextStyle(
                    fontFamily: 'Lora',
                    fontSize: 45,
                  ),
                ),
                SvgPicture.asset('img/logo.svg',
                  height: height * 0.15,
                  width: width * 0.2,
                ),
              ]
          ),

          Container(
            width: width,
            height: height * 0.55,
            decoration: const BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100.0)
                )
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 15.0),
                  height: height * 0.28,
                  width: width * 0.7,
                  child: Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.black12,
                                    width: 3
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(100))
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _controllerEmail,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Escriba su correo electrónico",
                                  label: Text("Correo electrónico"),
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.all(5),
                                  hintStyle:  TextStyle(
                                      color: Colors.white
                                  )
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.black12,
                                    width: 2
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(100))
                            ),
                            child: TextFormField(
                              obscureText: true,
                              controller: _controllerPassword,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Escriba su contraseña",
                                  label: Text("Contraseña"),
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.all(5),
                                  hintStyle: TextStyle(
                                      color: Colors.white
                                  )
                              ),
                            ),
                          ),
                          ElevatedButton(onPressed: (){
                            checkEmailAndPassword();
                          }, child: const Text('Iniciar sesión')),
                          ElevatedButton(onPressed: (){
                            Navigator.push(context, 
                            MaterialPageRoute(builder: (context) => NewUser()));
                          }, child: const Text('Regístrate')),
                          InkWell(
                            child: const Text("¿Has olvidado tu contraseña?", style: TextStyle( color: Colors.white),),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const Forgot()));
                            },
                          )
                        ],
                      )
                  ),
                ),
                SizedBox(

                  height: height * 0.09,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Image.asset('img/logoGoogle.png'),
                        iconSize: height,
                        onPressed: (){
                          singUpAndSingInWithGoogle();
                        } ,
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 25),
                    child: Text("!Bienvenidos!",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Lora',
                          fontSize: 30
                      ),
                    )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
