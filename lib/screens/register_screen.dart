import 'package:e_commerce/constants/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

import '../state/auth_state.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameField = TextEditingController();
  final _emailField = TextEditingController();
  final _passwordField = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _hidePassword = true;

  @override
  void dispose() {
    _usernameField.dispose();
    _emailField.dispose();
    _passwordField.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
      final email = _emailField.text;
      final password = _passwordField.text;

      await dio.post('/users', data: {
        "name": _usernameField.text,
        "email": email,
        "password": password,
        "avatar": "https://picsum.photos/800"
      });

      if (!mounted) return;

      final auth = context.read<AuthState>();
      await auth.login(email,password);

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
            (_) => false,
      );
    } catch (e) {
      if (!mounted) return;
      if (e is DioException && e.response != null) {
        print("❌ API REJECTED IT: ${e.response?.data}");
      } else {      print("❌ REGISTER ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed. Try again.')),
      );
    }
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Join Shoppr',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 28),
                TextFormField(
                  controller: _usernameField,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                  v!.length < 3 ? 'At least 3 characters' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailField,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Email is required';
                    }

                    if (!v.contains('@')) {
                      return 'Enter a valid email (missing @ & must end with .com)';
                    }

                    if (!v.trim().endsWith('.com')) {
                      return 'Email must end with .com';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordField,
                  obscureText: _hidePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hidePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() => _hidePassword = !_hidePassword);
                      },
                    ),
                  ),
                  validator: (v) =>
                  v!.length < 6 ? 'At least 6 characters' : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _register,
                    child: _isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text('Create account'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
