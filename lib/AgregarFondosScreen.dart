import 'package:flutter/material.dart';
import 'apis/user_api.dart';

class AgregarFondosScreen extends StatefulWidget {
  const AgregarFondosScreen({super.key});

  @override
  State<AgregarFondosScreen> createState() => _AgregarFondosScreenState();
}

class _AgregarFondosScreenState extends State<AgregarFondosScreen> {
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();

  Future<void> agregarFondosHandler() async {
    final cantidad = double.tryParse(cantidadController.text);
    final descripcion = descripcionController.text;

    if (cantidad == null || descripcion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, llena todos los campos correctamente.")),
      );
      return;
    }

    try {
      final userApi = UserApi();
      await userApi.agregarFondos(
        monto: cantidad,
        descripcion: descripcion,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fondos agregados correctamente")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al agregar fondos: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Fondos'),
        backgroundColor: const Color(0xFF00BFA6),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "País: Honduras",
              style: TextStyle(fontSize: 16, color: Colors.teal),
            ),
            const SizedBox(height: 8),
            const Text(
              "Selecciona tu mejor opción",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wallet, size: 50, color: Colors.purple),
                SizedBox(width: 16),
                Icon(Icons.account_balance, size: 50, color: Colors.teal),
                SizedBox(width: 16),
                Icon(Icons.paypal, size: 50, color: Colors.blue),
              ],
            ),
            const SizedBox(height: 24),
            const TextField(
              decoration: InputDecoration(
                labelText: "Visa",
                hintText: "1234123412341234",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: "Numeros de atrás",
                hintText: "123",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: cantidadController,
              decoration: const InputDecoration(
                labelText: "Cantidad",
                hintText: "Cantidad a agregar",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(
                labelText: "Descripción",
                hintText: "Descripción de la transacción",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: agregarFondosHandler,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BFA6),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text("Agregar Fondos"),
            ),
          ],
        ),
      ),
    );
  }
}
