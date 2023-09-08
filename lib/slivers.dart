import 'package:adopt_me/pets.dart';
import 'package:adopt_me/profilePet.dart';
import 'package:flutter/material.dart';
import 'package:adopt_me/formPets.dart';

class SliverPets extends StatefulWidget {
  final List<Pets> pets;
  const SliverPets({ required this.pets});

  @override
  State<SliverPets> createState() => _SliverPetsState();
}

class _SliverPetsState extends State<SliverPets> {
  TextStyle decoration(double size){
    return TextStyle(
      fontSize: size,
      fontFamily: 'Helvetica'
    );
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            // Configurar la URL de la imagen para el índice actual.
                            final imageUrl = widget.pets[index].url;
                            print(imageUrl);
                            return InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.indigo, width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(15))
                                ),
                                margin: EdgeInsets.all(5),
                                alignment: Alignment.center,
                                height: height * 0.2,
                                width: width * 0.8,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      height: height * 0.2,
                                      width: width * 0.28,
                                      child: Image(
                                        image: NetworkImage(imageUrl),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(widget.pets[index].nombre, style: decoration(24),),
                                        Text("Raza: "+widget.pets[index].raza, style: decoration(14),),
                                        Text("Ubicacion: "+widget.pets[index].city+",\n "+widget.pets[index].departament, style: decoration(14),)
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                  String nombre = widget.pets[index].nombre;
                                  int edad = widget.pets[index].edad;
                                  String raza = widget.pets[index].raza;
                                  String address = widget.pets[index].address;
                                  int phone = widget.pets[index].phone;
                                  String departament = widget.pets[index].departament;
                                  String city = widget.pets[index].city;
                                  String url = widget.pets[index].url;
                                  String email = widget.pets[index].email;
                                  String id = widget.pets[index].id;
                                  Pets pet = Pets(nombre: nombre, edad: edad, raza: raza, address: address, phone: phone, departament: departament, city: city, url: url, email: email, id: id);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => ProfilePet(pet: pet,))
                                  );
                              },
                            );
                          },
                          childCount: widget.pets.length,
                        ),
                      ),
                    ],
                  );
  }
}