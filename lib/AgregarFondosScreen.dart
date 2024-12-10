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
  final TextEditingController tokenController = TextEditingController();
  int selectedPaymentOption = 0;

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

  void selectPaymentOption(int option) {
    setState(() {
      selectedPaymentOption = option;
    });
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
          
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.wallet, size: 50, color: Colors.purple),
                  onPressed: () {
                    selectPaymentOption(1); 
                  },
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    selectPaymentOption(2); 
                  },
                  child: const Icon(
                    Icons.ac_unit, 
                    size: 50,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500), 
              child: selectedPaymentOption == 1
                  ? Column(
                      key: const ValueKey<int>(1),
                      children: [
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
                      ],
                    )
                  : selectedPaymentOption == 2
                      ? Column(
                          key: const ValueKey<int>(2),
                          children: [
                            const Text("Por favor, ingresa tu Token", style: TextStyle(fontSize: 16)),
                            const SizedBox(height: 16),
                            TextField(
                              controller: tokenController,
                              decoration: const InputDecoration(
                                labelText: "Token de Bitcoin",
                                hintText: "Ingresa el token de tu wallet",
                                border: OutlineInputBorder(),
                              ),
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
                          ],
                        )
                      : Container(), 
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
