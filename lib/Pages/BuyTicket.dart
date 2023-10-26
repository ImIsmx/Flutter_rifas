import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class BuyTicket extends StatefulWidget {
  final String idDoc;
  final int ticketNumber;

  const BuyTicket({required this.idDoc, required this.ticketNumber});

  @override
  State<BuyTicket> createState() => _BuyTicketState();
}

class _BuyTicketState extends State<BuyTicket> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  void _updateDocument() async {
    String name = nameController.text;
    String phoneNumber = phoneNumberController.text;

    await FirebaseFirestore.instance
        .collection("boletos")
        .doc(widget.idDoc)
        .set(
      {
        'comprador': name,
        'telefonoComprador': phoneNumber,
        'reservado': true,
      },
      SetOptions(merge: true),
    );
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
                  controller: nameController,
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
                  controller: phoneNumberController,
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