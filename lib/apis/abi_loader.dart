import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAbiFromAssets() async {
  return await rootBundle.loadString('assets/remesas_abi.json');
}