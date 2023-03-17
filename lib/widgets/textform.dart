import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextForm extends StatelessWidget {
  const MyTextForm({
    super.key,
    required this.controlador,
    required this.label,
    required this.funcionValidacion,
    this.tipoInput,
    this.tipoTeclado,
    this.hint,
    this.esconder,
    this.usarMaximo,
    this.maximoCaracteres,
  });
  final TextEditingController controlador;
  final String label;
  final String? hint;
  final String? Function(String?)? funcionValidacion;
  final List<TextInputFormatter>? tipoInput;
  final TextInputType? tipoTeclado;
  final bool? esconder;
  final bool? usarMaximo;
  final int? maximoCaracteres;

  @override
  Widget build(BuildContext context) {
    final max = usarMaximo ?? false;
    return TextFormField(
      maxLength: maximoCaracteres,
      maxLines: max ? null : 1,
      controller: controlador,
      keyboardType: tipoTeclado,
      inputFormatters: tipoInput,
      validator: funcionValidacion,
      obscureText: esconder ?? false,
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          borderSide: BorderSide(color: Colors.blue, width: 3),
        ),
        errorStyle: const TextStyle(color: Colors.red),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          borderSide: BorderSide(color: Colors.red, width: 3),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(color: Colors.blue, width: 1),
        ),
        hintText: hint,
        labelText: label,
        labelStyle: const TextStyle(color: Colors.blue),
      ),
    );
  }
}
