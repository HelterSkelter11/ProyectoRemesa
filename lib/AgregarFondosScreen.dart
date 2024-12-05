import 'package:flutter/material.dart';

class AgregarFondosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Fondos'),
        backgroundColor: Color(0xFF00BFA6),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "País: Honduras",
              style: const TextStyle(fontSize: 16, color: Colors.teal),
            ),
            const SizedBox(height: 8),
            Text(
              "Selecciona tu mejor opción",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wallet, size: 50, color: Colors.purple),
                const SizedBox(width: 16),
                Icon(Icons.account_balance, size: 50, color: Colors.teal),
                const SizedBox(width: 16),
                Icon(Icons.paypal, size: 50, color: Colors.blue),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: const InputDecoration(
                labelText: "Correo",
                hintText: "ejemplo@gmail.com",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: "Cantidad",
                hintText: "Cantidad a agregar",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: "Descripción",
                hintText: "Descripción de la transacción",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Fondos agregados correctamente")),
                );
                Navigator.pop(context); 
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00BFA6),
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
