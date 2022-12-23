import 'package:flutter/material.dart';

enum InputType { email, name, learnLang, nativeLang, other, pwd }

InputDecoration inputDecoration({
  required InputType type,
  required String label,
  VoidCallback? togglePassVisibility,
  bool isPassHidden = false,
}) {
  return InputDecoration(
    prefixIcon: _iconDecorationHandle(type),
    suffixIcon: type == InputType.pwd
        ? GestureDetector(
            onTap: togglePassVisibility ?? () {},
            child: Icon(isPassHidden ? Icons.visibility_off : Icons.visibility,
                color: isPassHidden ? Colors.black38 : Colors.black // Add this line
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
      color: Color(0xff094f27),
    ),
    labelText: label,
    labelStyle: const TextStyle(fontSize: 12),
  );
}

Widget? _iconDecorationHandle(InputType type) {
  switch (type) {
    case InputType.email:
      return _buildIconData(Icons.alternate_email);
    case InputType.pwd:
      return _buildIconData(Icons.password);
    case InputType.nativeLang:
      return _buildIconData(Icons.language_rounded);
    case InputType.name:
      return _buildIconData(Icons.person);
    case InputType.learnLang:
      return _buildIconData(Icons.translate_outlined);
    default:
      return null;
  }
}

Icon? _buildIconData(IconData? i) {
  if (i == null) return null;
  return Icon(i, size: 14.0);
}