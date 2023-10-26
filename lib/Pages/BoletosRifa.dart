import 'package:app/Pages/BuyTicket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class BoletosRifa extends StatefulWidget {

  final String idDoc;

  const BoletosRifa({super.key, required this.idDoc});

  @override
  State<BoletosRifa> createState() => _BoletosRifaState();
}

class _BoletosRifaState extends State<BoletosRifa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Boletos de la rifa"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("boletos")
            .where('idRifa', isEqualTo: widget.idDoc)
            .where('reservado',  isEqualTo: false )
            .snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return CircularProgressIndicator();
          }
          // var boletos = snapshot.data!.docs;

          List<DocumentSnapshot> docs = snapshot.data!.docs;
          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index){

                final DocumentSnapshot boletos = docs[index];

                return Card(
                  child: ListTile(
                    leading: Icon(Icons.shop),
                    title: Text(boletos['numeroBoleto'].toString(), style: TextStyle(fontSize: 18 ),),
                    subtitle: Text(boletos['reservado'].toString()),

                    onTap: (){
                      print("hola" + boletos['numeroBoleto'].toString());
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> BuyTicket(idDoc: boletos.id, ticketNumber: boletos['numeroBoleto'],)),);

                    },
                  ),
                );
              }
          );

        },
      ),
    );
  }
}