import 'package:flutter/material.dart';
import 'register_screen.dart'; 
import 'DashboardScreen.dart'; // Asegúrate de importar DashboardScreen
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

final supabase = Supabase.instance.client;

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    Future<void> login(BuildContext context) async {
      final username = usernameController.text.trim();
      final password = passwordController.text.trim();

      if (username.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, complete todos los campos')),
        );
        return;
      }

      final hashedPassword = sha256.convert(utf8.encode(password)).toString();

      try {
        final response = await supabase
            .from('user')
            .select('*')
            .eq('username', username)
            .eq('password', hashedPassword)
            .maybeSingle(); 

        if (response != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Inicio de sesión exitoso')),
          );
          // Redirige a DashboardScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuario o contraseña incorrectos')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al iniciar sesión: $e')),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            color: const Color(0xFF71C3A7),
            height: 100,
          ),
          const SizedBox(height: 20),
          const Text(
            'Bienvenido',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Usuario'),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(hintText: 'Usuario'),
                ),
                const SizedBox(height: 20),
                const Text('Contraseña'),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'Contraseña'),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () => login(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF71C3A7),
                      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    ),
                    child: const Text(
                      'Iniciar Sesión',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: const Text('+ Crear Cuenta'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/LoginPic.jpg'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Container(
            color: const Color(0xFF71C3A7),
            height: 50,
          ),
        ],
      ),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://rdnhybyetgahkgcckzln.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJkbmh5YnlldGdhaGtnY2NremxuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE5NTE0MTYsImV4cCI6MjA0NzUyNzQxNn0.R-DD87eFK4jSpwi2ONZ8bcFWzUhZTyA6GEpWGwHJC-k',
  );
  
  runApp(const MaterialApp(
    home: LoginScreen(),
  ));
}
