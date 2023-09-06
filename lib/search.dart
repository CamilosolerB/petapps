import 'package:adopt_me/formPets.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => FormPets()));
            },
            child: Text("Dar en Adopcion"),
          ),
          Container(
            height: height *0.73,
            width: width *0.9,
            child: CustomScrollView(
              slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.indigo,
                  height: height * 0.2,
                  width: width *0.8,
                  child: Text('Item: $index'),
                );
              },
              childCount: 5,
            ),
          ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
