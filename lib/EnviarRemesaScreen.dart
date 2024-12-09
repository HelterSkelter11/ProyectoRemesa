import 'package:flutter/material.dart';
import 'apis/user_api.dart';

class EnviarRemesaScreen extends StatefulWidget {
  const EnviarRemesaScreen({super.key});

  @override
  _EnviarRemesaScreenState createState() => _EnviarRemesaScreenState();
}

class _EnviarRemesaScreenState extends State<EnviarRemesaScreen> {
  String _selectedCurrency = 'Seleccionar Moneda';
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();

  void _showCurrencySelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Selecciona tu Moneda',
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Tether (USDT)'),
                onTap: () {
                  setState(() {
                    _selectedCurrency = 'Tether (USDT)';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('USDC (USDC)'),
                onTap: () {
                  setState(() {
                    _selectedCurrency = 'USDC (USDC)';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Dolares (USD)'),
                onTap: () {
                  setState(() {
                    _selectedCurrency = 'Dolares (USD)';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Euro (EU)'),
                onTap: () {
                  setState(() {
                    _selectedCurrency = 'Euro (EU)';
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> agregarTransaccion() async {
    final direccion = direccionController.text;
    final cantidad = double.tryParse(cantidadController.text) ?? 0.0;
    final descripcion = descripcionController.text;

    if (direccion.isEmpty || cantidad <= 0 || descripcion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, llena todos los campos correctamente.")),
      );
      return;
    }

    try {
      final userApi = UserApi();
      await userApi.agregarTransaccion(
        direccionDestino: direccion,
        monto: cantidad,
        descripcion: descripcion,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transaccion agregados correctamente")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al agregar Transaccion: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Enviar Remesa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: direccionController,
                      decoration: const InputDecoration(
                        labelText: 'Dirección',
                        hintText: 'Introduce la dirección',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: cantidadController,
                      decoration: const InputDecoration(
                        labelText: 'Cantidad',
                        hintText: 'Introduce la cantidad',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: descripcionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        hintText: 'Introduce una descripción',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _showCurrencySelectionDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.attach_money, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(_selectedCurrency),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed:  agregarTransaccion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'Enviar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.teal,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      // Acción del icono de enviar
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.home, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {
                      // Acción del icono de configuración
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
