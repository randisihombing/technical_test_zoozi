import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/auth_provider.dart';
import 'login.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';
  AsyncValue<void>? registerState;

  bool isShow = true;

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      registerState = const AsyncValue.loading();
    });

    ref
        .read(registerProvider({
      'name': _name,
      'email': _email,
      'password': _password,
    }).future)
        .then((_) {
      setState(() {
        registerState = const AsyncValue.data(null);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Register successful, please login!')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }).catchError((error, stackTrace) {
      setState(() {
        registerState = AsyncValue.error(error, stackTrace);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = registerState?.isLoading ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Full Name'),
                onSaved: (value) => _name = value!.trim(),
                validator: (value) =>
                value != null && value.length >= 3 ? null : 'Enter valid name',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _email = value!.trim(),
                validator: (value) => value != null && value.contains('@')
                    ? null
                    : 'Enter valid email',
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      isShow ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        isShow = !isShow;
                      });
                    },
                  ),
                ),
                obscureText: isShow,
                onSaved: (value) => _password = value!.trim(),
                validator: (value) =>
                value != null && value.length >= 6 ? null : 'Minimum 6 characters',
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _submit,
                child: const Text('Register'),
              ),
              if (registerState != null && registerState!.hasError) ...[
                const SizedBox(height: 12),
                Text(
                  'Error: ${registerState!.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
