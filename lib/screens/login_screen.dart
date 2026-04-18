import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../screens/home_page.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FocusNode usernameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  bool _passwordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    usernameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  InputDecoration inputStyle(String label, IconData icon, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      prefixIcon: Icon(icon, color: Colors.orange),
      suffixIcon: suffix,
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 2)),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final user = await DatabaseHelper.instance.loginUser(
      usernameController.text.trim(),
      emailController.text.trim(),
      passwordController.text,
    );

    setState(() => _isLoading = false);

    if (user != null) {
      if (mounted) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => HomePage(
                    username: user['username'], email: user['email'])));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Invalid username, email or password!'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.orange.shade200,
                        blurRadius: 20,
                        spreadRadius: 5)
                  ],
                ),
                child: const Icon(Icons.school, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text('Student Portal',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800)),
              const SizedBox(height: 6),
              Text('Welcome back!',
                  style:
                  TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              const SizedBox(height: 24),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text('Login',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: usernameController,
                          focusNode: usernameFocus,
                          textInputAction: TextInputAction.next,
                          decoration: inputStyle('Username', Icons.person),
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).requestFocus(emailFocus),
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'Enter username'
                              : null,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: emailController,
                          focusNode: emailFocus,
                          textInputAction: TextInputAction.next,
                          decoration: inputStyle('Email', Icons.email),
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(passwordFocus),
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'Enter email'
                              : null,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: passwordController,
                          focusNode: passwordFocus,
                          textInputAction: TextInputAction.done,
                          obscureText: !_passwordVisible,
                          decoration: inputStyle('Password', Icons.lock,
                              suffix: IconButton(
                                icon: Icon(_passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () => setState(() =>
                                _passwordVisible = !_passwordVisible),
                              )),
                          onFieldSubmitted: (_) => _login(),
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'Enter password'
                              : null,
                        ),
                        const SizedBox(height: 24),
                        _isLoading
                            ? const CircularProgressIndicator(
                            color: Colors.orange)
                            : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(12)),
                            ),
                            onPressed: _login,
                            child: const Text('Login',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RegisterScreen())),
                          child: const Text("Don't have an account? Register",
                              style: TextStyle(color: Colors.orange)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}