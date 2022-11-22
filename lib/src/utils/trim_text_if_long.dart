import 'package:flutter/material.dart';

String trimTextIfLong(String text, {int maxCharacters = 15}) {
  if(text.isEmpty) return '-';
  String rightTrimmed = text.trimRight();
  final int characters = rightTrimmed.characters.length;
  if(characters <= maxCharacters) {
    return text;
  }
  String temp = rightTrimmed.substring(0, maxCharacters - 3);
  return '$temp ...';
}