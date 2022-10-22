import 'package:flutter/material.dart';

class FormSubmitBtn extends StatelessWidget {
  const FormSubmitBtn(
      {Key? key, required this.txt, required this.formState, required this.onSubmit})
      : super(key: key);

  final FormState? formState;
  final VoidCallback onSubmit;
  final String txt;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        onPressed: () {
          if (formState != null && formState!.validate()) {
            onSubmit();
          } else {
            print(
                'is form.state null: ${formState == null} .. is form valid: ${formState?.validate()}');
          }
        },
        padding: const EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text(txt, style: const TextStyle(color: Colors.white)));
  }
}
