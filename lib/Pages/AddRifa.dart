import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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

  TextEditingController txtNameController = TextEditingController();
  TextEditingController txtDescriptionController = TextEditingController();
  TextEditingController txtNumberBoletosController = TextEditingController();
  TextEditingController txtPrecioBoletosController = TextEditingController();
  TextEditingController txtDateController = TextEditingController();

  TextEditingController fechaIController = TextEditingController(text: DateTime.now().toString());
  TextEditingController fechaFController = TextEditingController(text: DateTime.now().toString());

  DateTime? fechainicio = DateTime.now();
  DateTime? fechafinal =  DateTime.now();

  final ImagePicker _picker = ImagePicker();
  firebase_storage.Reference? _storageReference;
  File? _image;

  final _form = GlobalKey<FormState>();

  _AddRifaState(this.idDoc) {
    if(idDoc.isNotEmpty){
      rifas.doc(idDoc).get().then((value) {
        txtNameController.text = value['nombre'];
        txtDescriptionController.text = value ['descripcion'];
        txtNumberBoletosController.text = value ['numeroBoletos'].toString();
        txtPrecioBoletosController.text = value ['precioBoletos'].toString();
        fechainicio= value['fechaInicio'].toDate();
        fechafinal = value ['fechaFin'].toDate();
        fechaIController.text = fechainicio.toString();
        fechaFController.text = fechafinal.toString();

        setState(() {});
      });

    }
  }
/*
  Future<void>crearBoletos(String rifaId, int cantidad) async{
    for (int i = 0; i<cantidad; i++){

      await FirebaseFirestore.instance.collection('boletos').add({'rifaId': i + 1, 'reservado':false });
    }
  }
*/
  Future<void> _getImageFromCamera() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if(image != null){
      setState(() {
        _image = File(image.path);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Agregar una rifa"),

      ),
      body: Form(
        key: _form,
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: TextFormField(
                controller: txtNameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Nombre"),
                validator: (value) {
                  if (value == "") {
                    return "Este campo es obligatorio";
                  }
                  return null;
                },
              ),

            ),
            Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: TextFormField(
                controller: txtDescriptionController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Descripción"),
                validator: (value) {
                  if (value == "") {
                    return "Este campo es obligatorio";
                  }
                  return null;
                },
              ),

            ),
            Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: TextFormField(
                controller: txtNumberBoletosController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Numero de boletos"),
                validator: (value) {
                  if (value == "") {
                    return "Este campo es obligatorio";
                  }
                  return null;
                },

              ),

            ),
            Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: TextFormField(
                controller: txtPrecioBoletosController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Precio del boleto"),
                validator: (value) {
                  if (value == "") {
                    return "Este campo es obligatorio";
                  }
                  return null;
                },
              ),

            ),

            //Aqui Va el calendario

            DateTimePicker(
              type: DateTimePickerType.date,
              dateMask: 'd MMM, yyyy',

              controller: fechaIController,
              firstDate:DateTime(2000),
              lastDate: DateTime(2101),
              icon: Icon(Icons.event),
              dateLabelText: 'Fecha de inicio', timeLabelText: 'Hora de inicio', onChanged: (val){
              fechainicio = DateTime.parse(val);
            },

            ),
            DateTimePicker(
              type: DateTimePickerType.date,
              dateMask: 'd MMM, yyyy',

              controller: fechaFController,
              firstDate:DateTime(2000),
              lastDate: DateTime(2101),
              icon: Icon(Icons.event),
              dateLabelText: 'Fecha de incio',
              timeLabelText: 'Hora de incio',
              onChanged: (val){
                fechafinal = DateTime.parse(val);
              },

            ),

            _image == null
                ? Text('No se ha seleccionado ninguna imagen')
                : Image.file(_image!, height: 200.0),

            ElevatedButton(
              onPressed: () async {
                await _getImageFromCamera();
              },
              child: Text('Elegir una foto'),
            ),
            Visibility(
                visible: idDoc.isNotEmpty,
                child: TextButton(
                  onPressed: () async{
                    await QuickAlert.show(
                      context: context,
                      type: QuickAlertType.confirm,
                      title: '¿Seguro?',
                      text: 'Desea eliminar el registro',
                      confirmBtnText: 'yes',
                      cancelBtnText: 'no',
                      onConfirmBtnTap: () async{
                        await rifas.doc(idDoc).delete();
                        Navigator.pop(context);
                      },
                      confirmBtnColor: Colors.purple,
                    );
                  },
                  style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.green),

                  ),
                  child: const Text(("Eliminar")),
                ))


          ],
        ),


      ),



      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _storageReference = firebase_storage.FirebaseStorage.instance
              .ref()
              .child('carpeta_destino/${DateTime.now()}.png');
          //Sube la imagen al buckquet
          await _storageReference?.putFile(_image!);

          //Obtiene la URL de descarga de la imagen
          String? downloadURL = await _storageReference?.getDownloadURL();
          print(downloadURL);

          Map<String, dynamic> rifaData = {
            'nombre': txtNameController.text,
            'descripcion': txtDescriptionController.text,
            'numeroBoletos': int.tryParse(txtNumberBoletosController.text) ?? 0,
            'precioBoletos': int.tryParse(txtPrecioBoletosController.text) ?? 0,
            'fechaInicio': fechainicio,
            'fechaFin': fechafinal,
            'urlImagen':downloadURL.toString(),

          };
          print('guardando');
          if (idDoc.isEmpty) {
            var nuevaRifa = await rifas.add(rifaData);

            //String idRifa = idDoc;
            int cantidadBoletos = int.parse(txtNumberBoletosController.text);

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
          return;
        },
        child: Icon(Icons.save_rounded),
      ),


    );

  }

}
