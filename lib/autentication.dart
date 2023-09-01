import 'package:adopt_me/home.dart';
import 'package:adopt_me/newUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:adopt_me/querys.dart';


class Authentication{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  Future<void>singOut() async{
    await _firebaseAuth.signOut();
  }

  Future<void> checkEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context
}) async{
    bool emailExist = await Petition().checkIfEmailExist(email);
    List<String> singInCheck = await _firebaseAuth.fetchSignInMethodsForEmail(email);
    if(emailExist) {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bienvenido a PetApp")));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Homepage()));
    } else {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Bienvenido a PetApp")));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NewUser()));
    }
    }

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
      if( result != null){
        if(user !=null && user.email != null){
          bool emailExist = await Petition().checkIfEmailExist(user.email!);
          if(emailExist) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Bienvenido a PetApp")));
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Homepage()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Bienvenido a PetApp")));
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NewUser()));
          }
        }
        // ignore: use_build_context_synchronously

      }
    }
  }

  Future<UserCredential?> singInWithFacebook(BuildContext  context) async {
    
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success){
      final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Bienvenido a PetApp")));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Homepage()));
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
    return null;
  }
}