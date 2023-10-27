import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class BuyTickets extends StatefulWidget {
  final String idDoc;
  final int ticketNumber;

  const BuyTickets({required this.idDoc, required this.ticketNumber});

  @override
  _BuyTicketsState createState() => _BuyTicketsState();
}

class _BuyTicketsState extends State<BuyTickets> {

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();

  void _updateDocument() async {
    String name = nombreController.text;
    String phoneNumber = telefonoController.text;

    await FirebaseFirestore.instance.collection('boletos').doc(widget.idDoc).set({
      'comprador':name,
      'telefono_comprador':phoneNumber,
      'reservado': true,},
      SetOptions(merge: true),);
    Navigator.pop(context);
  }
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Comprar Boleto número: ${widget.ticketNumber.toString()}"),
        ),
        body: Form(
          key: _form,
          child: Padding(
            padding: EdgeInsets.all(30.0),
            child: Column(
              children: [
                TextFormField(
                  controller: nombreController,
                  validator: (value) {
                    if (value == "") {
                      return "campo obligatorio";
                    }
                  },
                  decoration: InputDecoration(
                      labelText: "Nombre Comprador",
                      hintText: "Ingrese su nombre"),
                ),
                TextFormField(
                  controller: telefonoController,
                  validator: (value) {
                    if (value == "") {
                      return "Campo Obligatorio";
                    }
                  },
                  decoration: InputDecoration(
                      labelText: "Número de telefono",
                      hintText: "Ingrese su número telefonico"),
                ),
                TextButton(
                    onPressed: () {
                      var isValid = _form.currentState?.validate();

                      if (isValid == null || isValid == false) {
                        return;
                      } else {
                        _updateDocument();
                      }
                    },
                    child: Text("Guardar"))
              ],
            ),
          ),
        ));
  }
}