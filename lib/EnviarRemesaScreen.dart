import 'package:flutter/material.dart';

class EnviarRemesaScreen extends StatefulWidget {
  const EnviarRemesaScreen({super.key});

  @override
  _EnviarRemesaScreenState createState() => _EnviarRemesaScreenState();
}

class _EnviarRemesaScreenState extends State<EnviarRemesaScreen> {
  String _selectedCurrency = 'Seleccionar Moneda';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50], // Color de fondo más claro
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
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Dirección',
                        hintText: 'Introduce la dirección',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Cantidad',
                        hintText: 'Introduce la cantidad',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    const TextField(
                      decoration: InputDecoration(
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
                      onPressed: () {
                        // Acción de enviar remesa
                      },
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
