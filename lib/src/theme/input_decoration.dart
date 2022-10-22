import 'package:flutter/material.dart';

InputDecoration inputDecoration(
    {required String label, VoidCallback? togglePassVisibility, bool isPassHidden = false}) {
  return InputDecoration(
    prefixIcon: _iconDecorationHandle(label),
    suffixIcon: label == 'Password'
        ? GestureDetector(
            onTap: togglePassVisibility ?? () {},
            child: Icon(isPassHidden ? Icons.visibility_off : Icons.visibility,
                color: isPassHidden ? Colors.grey : Colors.black // Add this line
                ),
          )
        : const SizedBox(
            width: 3,
          ),
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    contentPadding: const EdgeInsets.fromLTRB(25.0, 10.0, 20.0, 10.0),
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
      borderSide: BorderSide(color: Color(0xff0E9447), width: 2.0),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
      borderSide: BorderSide(color: Color(0xff0E9447), width: 2.0),
    ),
    // isCollapsed: true,
    floatingLabelStyle: const TextStyle(
      color: Colors.green,
    ),
    labelText: label,
    labelStyle: const TextStyle(fontSize: 12),
  );
}

Widget? _iconDecorationHandle(String? labelTxt) {
  switch (labelTxt) {
    case 'Email':
      return _buildIconData(Icons.alternate_email);
    case 'Password':
      return _buildIconData(Icons.password);
    case 'Your language':
      return _buildIconData(Icons.language_rounded);
    case 'Name':
      return _buildIconData(Icons.person);
    case 'Language you want to learn':
      return _buildIconData(Icons.translate_outlined);

    default:
      return null;
  }
}

Icon? _buildIconData(IconData? i) {
  if (i == null) return null;
  return Icon(i, color: Colors.grey, size: 14.0);
}
