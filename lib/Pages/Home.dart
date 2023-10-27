import 'package:app/Pages/Rifas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'AddRifa.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rifas Publicadas"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Column(
                  children: [
                    Expanded(child: Image.network('https://assets.stickpng.com/thumbs/585e4bf3cb11b227491c339a.png')),
                    Text("Bienvenido Ismael")
                  ],

                )
            ),
            ListTile(
              leading: Icon(Icons.monetization_on),
              title: Text("Rifas"),
              onTap: (){

              },

            ),


            ListTile(
              leading: Icon(Icons.payment_sharp),
              title: Text("Boletos Apartados"),
              onTap:(){

              },
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('rifas').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot>snapshot){

          if(!snapshot.hasData){//si no contiene datos solamente nos regresara un circulo cargando
            return CircularProgressIndicator();
          }
          List<DocumentSnapshot> docs = snapshot.data!.docs;


          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context,index) {
                final DocumentSnapshot rifa = docs[index];
                return ListTile(
                  leading: Image.network(rifa['urlImagen']),

                  title: Text(rifa['nombre']),
                  subtitle: Text(rifa['descripcion']),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddRifa(idDoc: rifa.id,)),
                    );

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
            MaterialPageRoute(builder: (context) => AddRifa(idDoc: '',)),
          );
        },
        child: Icon(Icons.add_box_rounded),


      ),
    );
  }
}