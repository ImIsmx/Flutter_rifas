import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

import 'Home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _form = GlobalKey<FormState>();
  final txtUserController = TextEditingController();
  final txtPasswordController = TextEditingController();

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: txtUserController.text, password: txtPasswordController.text);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Acceso no valido..',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Inicio de sesion"),
        ),
        body: Form(
          key: _form,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                "https://assets.stickpng.com/thumbs/585e4bf3cb11b227491c339a.png",
                width: 180,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: TextFormField(
                  controller: txtUserController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Usuario"),
                  validator: (value) {
                    if (value == "") {
                      return "Este campo es obligatorio";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: TextFormField(

                  controller: txtPasswordController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Contraseña"),
                  validator: (value) {
                    if (value == "") {
                      return "Este campo es obligatorio";
                    }
                    return null;
                  },
                ),
              ),

              TextButton(
                onPressed: () {
                  var isValid = _form.currentState?.validate();
                  if (isValid == null || isValid == false) {
                    //funcion si no de lo contrario hace la funcion de login
                    return;
                  }
                  _login();
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.amber ),
                ),
                child: const Text("Accesar"),
              )

            ],
          ),
        ));
  }
}
