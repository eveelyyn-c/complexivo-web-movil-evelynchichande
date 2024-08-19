import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormDefault extends StatelessWidget {
  const TextFormDefault(
      {required this.textEditingController,
      required this.hintTextForm,
      super.key,
      this.keyboardType,
      this.maxLines,
      this.inputFormatter});

  final TextEditingController textEditingController;
  final String hintTextForm;
  final TextInputType? keyboardType;

  /*Si pongo en el tipo '?' quiere decir que es
  del tipo keyboardType o NULL :D att: DPP*/
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        inputFormatters: inputFormatter,
        maxLines: maxLines,
        keyboardType: keyboardType,
        controller: textEditingController,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black12,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black12,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          hintText: hintTextForm,
          hintStyle: const TextStyle(
            color: Colors.grey, // Cambia el color del hintText
          ),
        ),
      ),
    );
  }
}
