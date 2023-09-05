import 'package:adopt_me/firebase_options.dart';
import 'package:adopt_me/login.dart';
import 'package:adopt_me/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb; 
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart'; 

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCNELR-OaqHS4YPp6EEZZBbLhma2JSf7JE",
        appId: "1:562461045714:web:26c4e8846cff8d34838e0b",
        messagingSenderId:  "562461045714",
        projectId: "adoppet-98cf3",
        storageBucket: "adoppet-98cf3.appspot.com"
    )
  );
    if (kIsWeb) {
    await FacebookAuth.i.webAndDesktopInitialize(
        appId: "152275387919681",
        cookie: true,
        xfbml: true,
        version: "v15.0",
    );
  }
  runApp( const MyApp() );
}
//
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adopt Me',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WidgetTree(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return const Login();
  }
}