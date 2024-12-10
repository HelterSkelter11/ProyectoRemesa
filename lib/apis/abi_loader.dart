import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAbiFromAssets() async {
  return await rootBundle.loadString('assets/contract_abi.json');
}