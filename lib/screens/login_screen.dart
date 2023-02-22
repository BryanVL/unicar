import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unicar/providers/usuario_provider.dart';
import 'package:unicar/screens/register_screen.dart';
import 'package:unicar/screens/tab_bar_screen.dart';
import 'package:unicar/widgets/buttons.dart';
import 'package:unicar/widgets/textform.dart';
import 'package:string_validator/string_validator.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final correoController = TextEditingController();
  final passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 252, 252, 252), //const Color.fromARGB(255, 245, 254, 255),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 96.0, bottom: 64),
                child: Text(
                  textAlign: TextAlign.center,
                  'Bienvenido a Unicar',
                  style: TextStyle(
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
              boton(
                //TODO funcion para iniciar sesión
                funcion: () async {
                  if (_formKey.currentState!.validate()) {
                    final AuthResponse res = await Supabase.instance.client.auth.signInWithPassword(
                      email: correoController.text,
                      password: passController.text,
                    );
                    final Session? session = res.session;
                    final User? user = res.user;
                    if (user != null) {
                      ref.read(usuarioProvider.notifier).state = user.id;
                      final List comprobarPrimerInicio = await Supabase.instance.client
                          .from('usuario')
                          .select('id')
                          .eq('id', user.id);
                      if (comprobarPrimerInicio.isEmpty) {
                        await Supabase.instance.client.from('usuario').insert({'id': user.id});
                      }
                      print(user.id);
                      if (context.mounted) {
                        Navigator.of(context).pushReplacementNamed(TabBarScreen.kRouteName);
                      }
                    }
                  }
                },
                textoBoton: 'Iniciar sesión',
                paddingTodo: 12,
                textSize: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿No tienes cuenta?'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(RegisterScreen.kRouteName);
                    },
                    child: const Text('Registrate'),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'O continua con:',
                  style: TextStyle(fontSize: 18),
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
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.center,
                    textStyle: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {},
                  child: Row(
                    children: const [
                      Image(
                        height: 30,
                        width: 30,
                        image: AssetImage(
                          'lib/assets/googleIcon.png',
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Iniciar sesión con google',
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
