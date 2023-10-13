import 'package:adopt_me/autentication.dart';
import 'package:adopt_me/hamburguesa.dart';
import 'package:adopt_me/search.dart';
import 'package:adopt_me/services.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}


class _HomepageState extends State<Homepage> {
  bool _isSearching = false;
  final TextEditingController searchController = TextEditingController();
  void startSearch( bool state){
    setState(() {
      _isSearching = state;
    });
  }

  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSearching ? getAppBarSearching() : getAppBarNotSearching(),
      drawer: const Hamburguer(),
      bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index){
            setState((){
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations:const <Widget>[
            NavigationDestination(
                selectedIcon: Icon(Icons.home_filled),
                icon: Icon(Icons.home),
                label: 'Home'
            ),
            NavigationDestination(
                selectedIcon: Icon(Icons.pets),
                icon: Icon(Icons.pets),
                label: 'Mis mascotas'
            ),
          ]
      ),
      body: <Widget>[
        Search(),
        Services(),
      ][ currentPageIndex]
    );
  }

  PreferredSizeWidget? getAppBarNotSearching() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      title: const Text("Adoptar"),
        backgroundColor: Colors.indigo,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Lora',
          fontSize: 25
        ),
    );
  }
  PreferredSizeWidget? getAppBarSearching() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      automaticallyImplyLeading: false,
      backgroundColor: Colors.indigo,
    );
  }
}
