import 'package:adopt_me/analitycs_services.dart';
import 'package:adopt_me/home.dart';
import 'package:adopt_me/newUser.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:adopt_me/querys.dart';

class Authentication{
  //analiticas
  int _counter = 0; 
  void counterSingIn() async{
    _counter++;
    await FirebaseAnalytics.instance.logEvent(
      name: 'registro',
      parameters: <String, dynamic>{
        'total_registro':_counter
      }
    );
  }
  //fin analiticas
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static String correo = "";
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  final AnalyticsServices _analyticsServices = AnalyticsServices();
  Future<void>singOut() async{
    await _firebaseAuth.signOut();
    correo = "";
  }
  //verifica correo
  Future<void> checkEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context
}) async{
    bool emailExist = await Petition().checkIfEmailExist(email);
    correo = email;
    if(emailExist) {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      counterSingIn();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bienvenido a PetApp")));
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Homepage()));
    }
    }
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async{
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password);
      correo = email;
  }
  //ingresa o registra por google
  Future<void> singUpAndSingInWithGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn( clientId: "562461045714-bfru0auqj70siouajna01o718dk061tq.apps.googleusercontent.com" );
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if(googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken
      );
      UserCredential result = await _firebaseAuth.signInWithCredential(authCredential);
      User? user = result.user;
      if(user !=null && user.email != null){
        bool emailExist = await Petition().checkIfEmailExist(user.email!);
        correo = user.email!;
        if(emailExist) {
          counterSingIn();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bienvenido a PetApp")));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Homepage()));
        } else {
          final currentContext = context;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Por favor registre los siguientes datos para continuar")));
          Navigator.push(currentContext, MaterialPageRoute(builder: (currentContext) =>  NewUser()));
        }
      }
      // ignore: use_build_context_synchronously

        }
  }

  Future<UserCredential?> singInWithFacebook(BuildContext  context) async {
    
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success){
      final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
      
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bienvenido a PetApp")));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Homepage()));
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
    return null;
  }
  Future<void> forgotPassword(String email,BuildContext context) async{
    await _firebaseAuth
      .sendPasswordResetEmail(email: email)
      .then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Verifica tu correo para la recuperacion de la clave"))))
      .catchError((error)=> print(error) );
  }
  //analiticas
}