import 'package:supabase_flutter/supabase_flutter.dart';

class User {
  final supabase = Supabase.instance.client;
  //final _storage = FlutterSecureStorage();

  Future<List<dynamic>> obtenerTransacciones(String userId) async {
  final response = await supabase
      .from('historia')
      .select('transacciones(*)')
      .eq('user_id', userId)
      .count();

  if (response.data.isEmpty == 0) {
    throw Exception('Error al obtener transacciones: $response');
  }

  return response.data;
}

  Future<void> agregarTransaccion({
  required bool entrada,
  required String direccion,
  required String descripcion,
  required double monto,
  required String stablecoin,
  required String estado,
  required String metodoConversion,
}) async {
  final response = await supabase.from('transaccion').insert({
    'entrada': entrada,
    'direccion': direccion,
    'descripcion': descripcion,
    'monto': monto,
    'stablecoin': stablecoin,
    'estado': estado,
    'metodo_conversion': metodoConversion,
  });

  if (response.error != null) {
    throw Exception('Error al agregar la transacción: ${response.error!.message}');
  }

  print('Transacción agregada: ${response.data}');
}
}
