import 'package:app/Pages/AddRifa.dart';
import 'package:app/Pages/BoletosRifa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class RifaPage extends StatefulWidget {
  const RifaPage({Key? key}) : super(key: key);

  @override
  State<RifaPage> createState() => _RifaPageState();
}

class _RifaPageState extends State<RifaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nuestras Rifas"),
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("rifas").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return CircularProgressIndicator();
          }

          List<DocumentSnapshot> docs = snapshot.data!.docs;
          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index){

                final DocumentSnapshot rifa = docs[index];

                return Card(
                  child: ListTile(
                    leading: Icon(Icons.shop),
                    title: Text(rifa['nombre'], style: TextStyle(fontSize: 18 ),),
                    subtitle: Text(rifa['descripcion']),

                    onTap: (){
                      print("hola" + rifa['nombre']);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> BoletosRifa(idDoc: rifa.id,)),);

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