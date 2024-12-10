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
  final TextEditingController tarjetaController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  int selectedPaymentOption = 0;

  Future<void> agregarFondosHandler() async {
    if (selectedPaymentOption == 1) {
      final cantidad = double.tryParse(cantidadController.text);
      final tarjeta = tarjetaController.text;
      final cvv = cvvController.text;
      final descripcion = descripcionController.text;

      if (cantidad == null || tarjeta.isEmpty || cvv.isEmpty || descripcion.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Por favor, llena todos los campos correctamente.")),
        );
        return;
      }
    } else if (selectedPaymentOption == 2) {
      final token = tokenController.text;
      final descripcion = descripcionController.text;

      if (token.isEmpty || descripcion.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Por favor, llena todos los campos correctamente.")),
        );
        return;
      }

      final result = await showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Confirmar Token"),
            content: TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: "Contraseña del token",
                hintText: "Ingresa tu contraseña",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, passwordController.text),
                child: const Text("Aceptar"),
              ),
            ],
          );
        },
      );

      if (result == null || result.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Operación cancelada")),
        );
        return;
      }
    }

    try {
      final userApi = UserApi();
      await userApi.agregarFondos(
        monto: selectedPaymentOption == 1 ? double.parse(cantidadController.text) : 0.0,
        descripcion: descripcionController.text,
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
                        TextField(
                          controller: tarjetaController,
                          decoration: const InputDecoration(
                            labelText: "Número de Tarjeta",
                            hintText: "1234123412341234",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: cvvController,
                          decoration: const InputDecoration(
                            labelText: "CVV",
                            hintText: "123",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
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
