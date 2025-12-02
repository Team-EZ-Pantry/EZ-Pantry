import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../providers/user_provider.dart';
import 'registration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState>  _formKey            = GlobalKey<FormState>();
  final TextEditingController _emailController    = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode             _emailFocusNode     = FocusNode();
  final FocusNode             _passwordFocusNode  = FocusNode();
  final double                _elementSpacing     = 15.0;

  // Track provider errors per fields
  String? _emailProviderError;
  String? _passwordProviderError;
  String? _generalError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _clearProviderErrors() {
    setState(() {
      _emailProviderError = null;
      _passwordProviderError = null;
      _generalError = null;
    });
  }

  Future<void> _handleLogin() async {
    _clearProviderErrors();
    
    if (!_formKey.currentState!.validate()) return;

    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.clearError();

    final bool success = await userProvider.login(
      _emailController.text,
      _passwordController.text,
    );

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<ActionDispatcher>(
          builder: (BuildContext context) => const MyHomePage(title: 'EZ Pantry'),
        ),
      );
    } else if (mounted && userProvider.error != null) {
      // Map provider errors to specific fields
      setState(() {
        if (userProvider.error!.contains('No account found with this email') ||
            userProvider.error!.contains('email')) {
          _emailProviderError = userProvider.error;
          _emailFocusNode.requestFocus();
        } else if (userProvider.error!.contains('Incorrect password')) {
          _passwordProviderError = userProvider.error;
          _passwordController.clear();
          _passwordFocusNode.requestFocus();
        } else if (userProvider.error!.contains('Network')) {
          _generalError = userProvider.error;
        } else {
          _generalError = userProvider.error; // Generic fallback
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Logo
                Image.asset(
                  '../../assets/logo/logo.png',
                  height: 300,
                  width: 500,
                ),
                SizedBox(height: _elementSpacing + 20),

                // Email
                TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    border: const OutlineInputBorder(),
                    errorText: _emailProviderError, // Provider error shown here
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) return 'Email is required';
                    if (!value.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                  onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: _elementSpacing),

                // Password
                TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    border: const OutlineInputBorder(),
                    errorText: _passwordProviderError,
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) return 'Password is required';
                    return null;
                  },
                  onFieldSubmitted: (_) => _handleLogin(),
                  textInputAction: TextInputAction.done,
                ),

                // General errors (network, unexpected)
                if (_generalError != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Theme.of(context).colorScheme.error,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      
                      // Error Text
                      Expanded(
                        child: Text(
                          _generalError!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ],

                SizedBox(height: _elementSpacing + 5),

                // Login Button with loading state
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    return ElevatedButton(
                      onPressed: userProvider.isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: userProvider.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 3),
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(fontSize: 18),
                            ),
                    );
                  },
                ),

                // Sign Up redirect
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => const RegistrationPage(),
                      ),
                    ),
                    child: const Text('New user? Sign up'),
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
