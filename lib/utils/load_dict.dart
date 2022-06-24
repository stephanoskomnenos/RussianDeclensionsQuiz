import 'dart:async';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

Future<List<List<String>>> loadDict(String fileName) async {
  final csvString = await rootBundle.loadString('assets/dict/$fileName');
  const converter = CsvToListConverter(fieldDelimiter: ',', eol: '\n');
  final dictList = converter
      .convert(csvString)
      .map((line) => line.map((field) => field.toString()).toList())
      .toList();
  return dictList;
}
