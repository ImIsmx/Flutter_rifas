import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';

class AddRifa extends StatefulWidget {
  final String idDoc;

  const AddRifa({super.key, required this.idDoc});

  @override
  State<AddRifa> createState() => _AddRifaState(this.idDoc);
}

class _AddRifaState extends State<AddRifa> {
  final String idDoc;

  CollectionReference rifas = FirebaseFirestore.instance.collection('rifas');
  CollectionReference boletos = FirebaseFirestore.instance.collection('boletos');

  TextEditingController nombreController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController numeroBoletosController = TextEditingController();
  TextEditingController precioBoletoController = TextEditingController();

  TextEditingController txtFechaInicioController =
  TextEditingController(text: DateTime.now().toString());
  TextEditingController txtFechaTerminoController =
  TextEditingController(text: DateTime.now().toString());

  DateTime? _startDate = DateTime.now();
  DateTime? _endDate = DateTime.now();

  _AddRifaState(this.idDoc) {
    if (idDoc.isNotEmpty) {
      rifas.doc(this.idDoc).get().then((value) {
        nombreController.text = value['nombre'];
        descripcionController.text = value['descripcion'];
        numeroBoletosController.text = value['numeroBoletos'].toString();
        precioBoletoController.text = value['precioBoleto'].toString();

        _startDate = value['fechaInicio'].toDate();
        _endDate = value['fechaFin'].toDate();

        txtFechaInicioController.text = _startDate.toString();
        txtFechaTerminoController.text = _endDate.toString();

        setState(() {});
      });
    }
  }


  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Añadir Rifa"),
      ),
      body: Form(
        key: _form,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              //Nombre
              TextFormField(
                controller: nombreController,
                validator: (value) {
                  if (value == "") {
                    return "Campo obligatorio";
                  }
                },
                decoration: InputDecoration(
                  //border: OutlineInputBorder(),
                    labelText: "Nombre",
                    hintText: "Ingrese el nombre de la rifa"),
              ),

              //Campo para la descripcion
              TextFormField(
                controller: descripcionController,
                validator: (value) {
                  if (value == "") {
                    return "Campo obligatorio";
                  }
                },
                decoration: InputDecoration(
                    labelText: "Descripcion",
                    hintText: "Ingrese descripcion de la rifa"),
              ),

              //Campo para el numero de boletos

              TextFormField(
                controller: numeroBoletosController,
                validator: (value) {
                  if (value == "") {
                    return "Campo obligatorio";
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Número de boletos",
                    hintText: "Ingrese el numero de boletos para la rifa"),
              ),

              TextFormField(
                controller: precioBoletoController,
                validator: (value) {
                  if (value == "") {
                    return "Campo obligatorio";
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Precio del boleto",
                    hintText: "Ingrese el precio de boleto para la rifa"),
              ),
              DateTimePicker(
                type: DateTimePickerType.date,
                dateMask: 'd MMM yyyy ',
                controller: txtFechaInicioController,
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
                icon: Icon(Icons.date_range),
                dateLabelText: "Fecha de inicio",
                onChanged: (val) {
                  _startDate = DateTime.parse(val);
                },
              ),

              DateTimePicker(
                type: DateTimePickerType.date,
                dateMask: 'd MMM yyyy ',
                controller: txtFechaTerminoController,
                firstDate: DateTime(2001),
                lastDate: DateTime(2101),
                icon: Icon(Icons.date_range_sharp),
                dateLabelText: "Fecha de Termino",
                onChanged: (val) {
                  _endDate = DateTime.parse(val);
                },
              ),

              Padding(
                padding: EdgeInsets.all(20),
                child: idDoc.isEmpty ? Container(): TextButton(
                    onPressed: () async {
                      if (idDoc.isNotEmpty) {
                        bool confirm = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirmación"),
                                content: Text(
                                    "¿Estas seguro que deseas eliminar la rifa con nombre:  " + nombreController.text + "?"),
                                actions: <Widget>[
                                  TextButton(onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                      child: Text("Cancelar")
                                  ),
                                  TextButton(onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                      child: Text("Eliminar")
                                  )
                                ],
                              );
                            });

                        if (confirm) {
                          await rifas.doc(idDoc).delete();
                          await boletos.doc(idDoc).delete();
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: Text("Eliminar")
                ),
              ),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          var isValid = _form.currentState?.validate();
          if (isValid == null || isValid == false) {
            return;
          } else {
            Map<String, dynamic> rifaData = {
              "nombre": nombreController.text,
              "descripcion": descripcionController.text,
              "numeroBoletos": int.tryParse(numeroBoletosController.text) ?? 0,
              "precioBoleto": int.tryParse(precioBoletoController.text) ?? 0,
              "fechaInicio": _startDate,
              "fechaFin": _endDate
            };



            if (idDoc.isEmpty) {
              var nuevaRifa = await rifas.add(rifaData);

              //String idRifa = idDoc;
              int cantidadBoletos = int.parse(numeroBoletosController.text);

              for(int i = 0; i < cantidadBoletos; i++){
                boletos.add({
                  "idRifa": nuevaRifa.id,
                  "numeroBoleto": i +1,
                  "reservado": false
                });
              }

            } else {
              await rifas.doc(idDoc).update(rifaData);
            }
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}