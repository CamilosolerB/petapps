import 'package:adopt_me/querys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class EventsFirebase extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  int contadorMosquera = 0;
  int contadorTotal = 0;
  int contadorPerdidos = 0;
  Petition petition = Petition();
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  //consulta inicial
  Future<void> statsInitialized() async{
    QuerySnapshot pets = await firestore.collection("Stats").get();
    try{
      for(QueryDocumentSnapshot document in pets.docs){
        contadorMosquera = document['totalMosquera'];
        contadorTotal = document['totalGeneral'];
        contadorPerdidos = document['totalPerdidos'];
      }
    }catch(e){
      print('Error al obtener las estadisticas: $e');
    }
  }
  //cambios en la bd
    Future<void> updateStats() async{
    String id = "Kv67YptsXG2i5lO9jPma";
    Map<String, dynamic> updateData = {
      'totalGeneral': contadorTotal,
      'totalMosquera': contadorMosquera,
      'totalPerdidos': contadorPerdidos
    };
    try{
      await firestore.collection("Stats").doc(id).update(updateData);
    }catch(e){
      print('Error updating document: $e');
    }
  }
  //logs
  void adoptMosquera() async{
    statsInitialized();
    int totalMosquera = await petition.countMosquera();
    contadorMosquera++;
    updateStats();
    contadorMosquera =  (contadorMosquera * 100 / totalMosquera).floor();
    analytics.logEvent(
      name: 'Adopcion_Mosquera',
      parameters: <String, dynamic>{
        'numero_personas': contadorMosquera,
      },
    );
  }

  void percentAdopt() async {
    statsInitialized();
    int totalGeneral = await petition.countDocumentsInPetsCollection();
    contadorTotal++;
    updateStats();
    contadorTotal =  (contadorTotal * 100 / totalGeneral).floor();
    analytics.logEvent(
      name: 'Numero_Adoptan',
      parameters: <String, dynamic>{
        'total_adoptan': contadorTotal,
      },
    );
  }

  void seeMissing() async {
    statsInitialized();
    contadorPerdidos++;
    updateStats();
    int totalGeneral = await petition.countDocumentsInPetsCollection();
    contadorPerdidos =  (contadorPerdidos * 100 / totalGeneral).floor();
    analytics.logEvent(
      name: 'Total_Revisan_Mascotas_Perdidas',
      parameters: <String, dynamic>{
        'total': contadorPerdidos,
      },
    );
  }
}
