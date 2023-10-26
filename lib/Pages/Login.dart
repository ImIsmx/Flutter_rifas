
import 'package:app/Pages/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final txtUserController = TextEditingController();
  final txtPasswordController = TextEditingController();

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: txtUserController.text, password: txtPasswordController.text);

      Navigator.push(
          context,
          MaterialPageRoute(builder: (context)  => HomePage())
      );

    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Sorry, something went wrong',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Form(
        key: _form,
        child: Column(
          children: [
            Image.network(
              "https://i.pinimg.com/736x/98/8d/ed/988ded77be6eb979a543696750d7986b.jpg",
              width: 280,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                controller: txtUserController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: "Usuario"),
                validator: (value) {
                  if (value == "") {
                    return "Este campo es obligatorio";
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                  controller: txtPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Contraseña"),
                  validator: (value) {
                    if (value == "") {
                      return "Este campo es obligatorio";
                    }
                  }),
            ),
            TextButton(
              onPressed: () {
                var IsValid = _form.currentState?.validate();

                if (IsValid == null || IsValid == false) {
                  return;
                }
                _login();
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              child: const Text("Acceder"),
            )
          ],
        ),
      ),
    );
  }
}