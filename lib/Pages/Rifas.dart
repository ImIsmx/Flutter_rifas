import 'package:app/Pages/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'AddRifa.dart';
import 'BoletosRifa.dart';
import 'Login.dart';

class Rifas extends StatefulWidget {
  const Rifas({Key? key}) : super(key: key);


  @override
  State<Rifas> createState() => _RifaState();

}

class _RifaState extends State<Rifas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("¡Rifas disponibles!"),
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('rifas').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot>snapshot){//

          if(!snapshot.hasData){//si no contiene datos solamente nos regresara un circulo cargando
            return CircularProgressIndicator();
          }
          List<DocumentSnapshot> docs = snapshot.data!.docs;


          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context,index) {
                final DocumentSnapshot rifa = docs[index];
                return ListTile(
                  //leading: const Icon(Icons.shopping_bag),
                  leading: Image.network(rifa['urlImagen']),
                  title: Text(rifa['nombre']),
                  subtitle: Text(rifa['descripcion']),

                  onTap: (){
                    print("hola" + rifa['nombre']);

                    Navigator.push(context, MaterialPageRoute(builder: (context) => BoletosRifa(idDoc: rifa.id,)),);

                  },
                );
              }
          );
        },

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
        child: Icon(Icons.person),


      ),
    );
  }
}