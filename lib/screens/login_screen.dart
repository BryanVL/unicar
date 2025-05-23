import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as r;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unicar/providers/database_provider.dart';
import 'package:unicar/screens/register_screen.dart';
import 'package:unicar/widgets/buttons.dart';
import 'package:unicar/widgets/textform.dart';
import 'package:string_validator/string_validator.dart';

import '../providers/login_provider.dart';
import '../providers/tema_provider.dart';

class LoginScreen extends r.ConsumerStatefulWidget {
  const LoginScreen({super.key});
  static const kRouteName = "/Login";
  @override
  r.ConsumerState<r.ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends r.ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final correoController = TextEditingController();
  final passController = TextEditingController();
  late final StreamSubscription<AuthState> _authStateSubscription;

  final SnackBar errorSnackBar = SnackBar(
    backgroundColor: Colors.blue[400],
    shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    content: const Text('Hubo un problema al iniciar sesión, intentalo de nuevo más tarde'),
  );

  void _iniciarSesion(String correo, String password) async {
    try {
      ref.read(databaseProvider.notifier).iniciarSesion(context, correo, password);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
    }
  }

  void _iniciarSesionProvider(Provider provider) async {
    try {
      ref.read(databaseProvider.notifier).iniciarSesionConProvider(provider);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
    }
  }

  @override
  initState() {
    _authStateSubscription =
        ref.read(databaseProvider.notifier).comprobarEstadoInicioConProvider(context);

    super.initState();
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    correoController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = ref.watch(temaProvider).when(
          data: (data) => data == 'claro' ? true : false,
          error: (error, stackTrace) => true,
          loading: () => true,
        );
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 96.0, bottom: 64),
                child: Text(
                  textAlign: TextAlign.center,
                  'Bienvenido a Unicar',
                  style: TextStyle(
                    color: tema ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 48,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32, bottom: 16.0, left: 32, right: 32),
                child: MyTextForm(
                  controlador: correoController,
                  tipoTeclado: TextInputType.emailAddress,
                  label: 'Email',
                  funcionValidacion: (String? value) {
                    if (!isEmail(value ?? '')) {
                      return 'Email no valido';
                    }

                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0, left: 32, right: 32),
                child: MyTextForm(
                  controlador: passController,
                  esconder: true,
                  label: 'Contraseña',
                  funcionValidacion: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'La contraseña no puede estar vacia';
                    }
                    return null;
                  },
                ),
              ),
              Boton(
                funcion: () {
                  if (_formKey.currentState!.validate()) {
                    _iniciarSesion(correoController.text, passController.text);
                  }
                },
                textoBoton: 'Iniciar sesión',
                paddingTodo: 12,
                textSize: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿No tienes cuenta?',
                    style: TextStyle(color: tema ? Colors.black : Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(RegisterScreen.kRouteName);
                    },
                    child: const Text('Registrate'),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'O continua con:',
                  style: TextStyle(fontSize: 18, color: tema ? Colors.black : Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    backgroundColor: Colors.blue[50],
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.center,
                    textStyle: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    ref.read(loginProviderProvider.notifier).state = false;
                    _iniciarSesionProvider(Provider.discord);
                  },
                  child: Row(
                    children: const [
                      Image(
                        height: 30,
                        width: 30,
                        image: AssetImage(
                          'lib/assets/discordLogo1.png',
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Continuar con Discord',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
