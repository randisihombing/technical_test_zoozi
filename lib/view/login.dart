import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:technical_test/component/text.dart';
import 'package:technical_test/provider/language_provider.dart';
import 'package:technical_test/view/register.dart';

import '../auth/auth_notifier.dart';
import '../helper/constant.dart';
import '../helper/i18n.dart';
import '../provider/auth_provider.dart';
import '../provider/theme_provider.dart';
import 'home.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  bool isShow = true;
  bool changeLang = false;

  AsyncValue<String>? loginResult; // simpan hasil login

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      loginResult = const AsyncValue.loading();
    });

    ref
        .read(loginProvider({'email': _email, 'password': _password}).future)
        .then((token) async {
      // Simpan token ke AuthNotifier
      await ref.read(authNotifierProvider.notifier).login(token);

      if (!mounted) return;
      setState(() {
        loginResult = AsyncValue.data(token);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );

      // Lanjut navigasi ke halaman utama
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }).catchError((error, stackTrace) {
      if (!mounted) return;
      setState(() {
        loginResult = AsyncValue.error(error, stackTrace);
      });
    });
  }

  void _toggleLanguage() {
    final current = ref.read(languageProvider);
    final nextLocale = current.languageCode == 'en' ? const Locale('id') : const Locale('en');
    ref.read(languageProvider.notifier).state = nextLocale;
    changeLang = !changeLang;
  }

  @override
  Widget build(BuildContext context) {
    final lang = I18n.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const RText('lang.greeting'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: MyMargin.standard),
            child: InkWell(
              onTap: _toggleLanguage,
              child: RText(
                  changeLang ? "lang.id" : "lang.en"
              ),
            ),
          ),
          PopupMenuButton<ThemeMode>(
            icon: const Icon(Icons.color_lens),
            onSelected: (mode) {
              ref.read(themeModeProvider.notifier).state = mode;
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: ThemeMode.light,
                child: Text('Light'),
              ),
              const PopupMenuItem(
                value: ThemeMode.dark,
                child: Text('Dark'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                key: const ValueKey('email'),
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _email = value!.trim(),
                validator: (value) =>
                value != null && value.contains('@') ? null : 'Invalid email',
              ),
              TextFormField(
                key: const ValueKey('password'),
                decoration: InputDecoration(
                  labelText: I18n.of(context)!.t("lang.password"),
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
                value != null && value.length >= 6 ? null : 'Password too short',
              ),
              const SizedBox(height: 20),
              if (loginResult == null || loginResult!.isLoading)
                ElevatedButton(
                  onPressed: _submit,
                  child: loginResult?.isLoading == true
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : RText(lang!.t('lang.login')),
                      // : const Text('Login'),
                ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  );
                },
                child: const RText('lang.dontHaveAccountYet'),
              ),
              if (loginResult != null && loginResult!.hasError) ...[
                Text('Error: ${loginResult!.error}', style: const TextStyle(color: Colors.red)),
                ElevatedButton(
                  onPressed: _submit,
                  child: const RText('lang.retry'),
                ),
              ],
              if (loginResult != null && loginResult!.hasValue)
                const RText('lang.loggedInSuccess'),
            ],
          ),
        ),
      ),
    );
  }
}

