import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final FocusNode usernameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    super.dispose();
  }

  void _autoFillEmail() {
    String text = emailController.text.trim();
    if (text.isNotEmpty && !text.contains('@')) {
      emailController.text = '$text@gmail.com';
      emailController.selection = TextSelection.fromPosition(
        TextPosition(offset: emailController.text.length),
      );
    }
  }

  bool _validatePassword(String value) {
    final regex =
    RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&^_-]).{8,}$');
    return regex.hasMatch(value);
  }

  InputDecoration inputStyle(String label, IconData icon, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      prefixIcon: Icon(icon, color: Colors.orange),
      suffixIcon: suffix,
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.orange, width: 2),
      ),
    );
  }

  Future<void> _register() async {
    _autoFillEmail();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (await DatabaseHelper.instance.usernameExists(username)) {
      setState(() => _isLoading = false);
      _showSnackBar('Username already taken!', Colors.red);
      return;
    }
    if (await DatabaseHelper.instance.emailExists(email)) {
      setState(() => _isLoading = false);
      _showSnackBar('Email already registered!', Colors.red);
      return;
    }

    final result =
    await DatabaseHelper.instance.insertUser(username, email, password);
    setState(() => _isLoading = false);

    if (result > 0) {
      _showSnackBar('Registration successful!', Colors.green);
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    } else {
      _showSnackBar('Registration failed. Try again!', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
    ));
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
              Text('Create your account',
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
                        const Text('Register',
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
                          validator: (v) {
                            if (v == null || v.isEmpty)
                              return 'Enter username';
                            if (v.length < 3) return 'Min 3 characters';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: emailController,
                          focusNode: emailFocus,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: inputStyle('Email', Icons.email),
                          onFieldSubmitted: (_) {
                            _autoFillEmail();
                            FocusScope.of(context).requestFocus(passwordFocus);
                          },
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Enter email';
                            if (RegExp(r'[A-Z]').hasMatch(v))
                              return 'Use lowercase only';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: passwordController,
                          focusNode: passwordFocus,
                          textInputAction: TextInputAction.next,
                          obscureText: !_passwordVisible,
                          decoration: inputStyle('Password', Icons.lock,
                              suffix: IconButton(
                                icon: Icon(_passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () => setState(
                                        () => _passwordVisible = !_passwordVisible),
                              )),
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(confirmPasswordFocus),
                          validator: (v) {
                            if (v!.isEmpty) return 'Enter password';
                            if (!_validatePassword(v))
                              return 'Min 8 chars, letter, number & special char';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: confirmPasswordController,
                          focusNode: confirmPasswordFocus,
                          obscureText: !_confirmPasswordVisible,
                          decoration: inputStyle(
                              'Confirm Password', Icons.lock_outline,
                              suffix: IconButton(
                                icon: Icon(_confirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () => setState(() =>
                                _confirmPasswordVisible =
                                !_confirmPasswordVisible),
                              )),
                          validator: (v) {
                            if (v!.isEmpty) return 'Confirm password';
                            if (v != passwordController.text)
                              return 'Passwords do not match';
                            return null;
                          },
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
                            onPressed: _register,
                            child: const Text('Register',
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
                                  builder: (_) => const LoginScreen())),
                          child: const Text('Already have an account? Login',
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