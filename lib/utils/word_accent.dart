import 'dart:convert';

String addAccent(String word) {
  final accentSign = utf8.decode([0xcc, 0x81]);
  return word.replaceAll('\'', accentSign);
}