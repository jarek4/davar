import 'package:flutter/material.dart';

String trimTextIfLong(String text, {int maxCharacters = 15}) {
  final int characters = text.characters.length;
  if(characters <= maxCharacters) return text;
  String temp = text.substring(0, maxCharacters - 3);
  return '$temp...';
}