import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:string_validator/string_validator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../widgets/buttons.dart';
import '../widgets/textform.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  static const kRouteName = "/RegisterScreen";
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final correoController = TextEditingController();
  final passController = TextEditingController();
  final repeatPassController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 245, 254, 255),
        title: const Text('Registrate'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 32,
                  left: 32,
                  right: 32,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: Colors.blue,
                        width: 3,
                      ),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 8, right: 8),
                  child: const Text(
                    textAlign: TextAlign.center,
                    'Una vez rellenes los datos y pulses en el botón te llegará un correo con un link que debes pulsar para validar tu cuenta',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32, bottom: 16.0, left: 32, right: 32),
                child: MyTextForm(
                  controlador: correoController,
                  tipoTeclado: TextInputType.emailAddress,
                  label: 'Correo',
                  funcionValidacion: (String? value) {
                    if (!isEmail(value ?? '')) {
                      return 'Email no valido';
                    }

                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0, bottom: 8, left: 32, right: 32),
                child: MyTextForm(
                  controlador: passController,
                  esconder: true,
                  label: 'Contraseña',
                  funcionValidacion: (String? value) {
                    if (passController.text == '') {
                      return 'La contraseña no puede estar vacia';
                    }
                    if (passController.text.length < 5) {
                      return 'La contraseña debe tener 5 o más caracteres';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0, left: 32, right: 32),
                child: MyTextForm(
                  controlador: repeatPassController,
                  esconder: true,
                  label: 'Repite la contraseña',
                  funcionValidacion: (String? value) {
                    if (repeatPassController.text == '') {
                      return 'La contraseña no puede estar vacia';
                    }
                    if (repeatPassController.text.length < 5) {
                      return 'La contraseña debe tener 5 o más caracteres';
                    }
                    if (repeatPassController.text != passController.text) {
                      return 'El campo contraseña y repite constraseña no son iguales';
                    }
                    return null;
                  },
                ),
              ),
              boton(
                //TODO funcion para registrar con correo y contraseña
                funcion: () async {
                  if (_formKey.currentState!.validate()) {
                    final AuthResponse res = await Supabase.instance.client.auth.signUp(
                      email: correoController.text,
                      password: passController.text,
                    );
                    final Session? session = res.session;
                    final User? user = res.user;
                  }
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                textoBoton: 'Registrate',
                paddingTodo: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
