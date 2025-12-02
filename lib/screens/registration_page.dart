import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../providers/user_provider.dart';
import 'login_page.dart';


class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<FormState>  _formKey            = GlobalKey<FormState>();
  final TextEditingController _emailController    = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode             _emailFocusNode     = FocusNode();
  final FocusNode             _usernameFocusNode  = FocusNode();
  final FocusNode             _passwordFocusNode  = FocusNode();
  
  // Track provider errors per field
  String? _emailProviderError;
  String? _usernameProviderError;
  String? _passwordProviderError;
  String? _generalError;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearProviderErrors() {
    setState(() {
      _emailProviderError = null;
      _usernameProviderError = null;
      _passwordProviderError = null;
      _generalError = null;
    });
  }

  Future<void> _handleRegistration() async {
    _clearProviderErrors();
    
    if (!_formKey.currentState!.validate()) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.clearError();

    final bool success = await userProvider.register(
      _usernameController.text,
      _emailController.text,
      _passwordController.text,
    );

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<ActionDispatcher>(builder: (_) => const MyHomePage(title: 'EZ Pantry')),
      );
    } else if (mounted && userProvider.error != null) {
      // Map provider errors to specific fields
      setState(() {
        final String error = userProvider.error!;
        
        if (error.contains('email') || error.contains('Email')) {
          _emailProviderError = error;
        } else if (error.contains('Username') || 
                   error.contains('username') || 
                   error.contains('Invalid Characters')) {
          _usernameProviderError = error;
        } else if (error.contains('password') || error.contains('Password')) {
          _passwordProviderError = error;
        } else if (error.contains('Network')) {
          _generalError = error;
        } else {
          _generalError = error; // Generic fallback
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image.asset('../../assets/logo/logo.png', height: 300, width: 500),
                const SizedBox(height: 35),
                
                // Email
                TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Email', 
                    hintText: 'Enter your email',
                    border: const OutlineInputBorder(),
                    errorText: _emailProviderError,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (!value.contains('@')) return 'Invalid email format';
                    return null;
                  },
                  onFieldSubmitted: (_) => _usernameFocusNode.requestFocus(),
                ),

                const SizedBox(height: 15),

                // Username
                TextFormField(
                  controller: _usernameController,
                  focusNode: _usernameFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Username', 
                    hintText: 'Choose a username',
                    border: const OutlineInputBorder(),
                    errorText: _usernameProviderError,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (value.length > 30) return 'Too long';
                    return null;
                  },
                  onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
                ),

                const SizedBox(height: 15),

                // Password
                TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'At least 6 characters',
                    border: const OutlineInputBorder(),
                    errorText: _passwordProviderError,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (value.length < 6) return 'Password must be 6+ characters long';
                    return null;
                  },
                  onFieldSubmitted: (_) => _handleRegistration(),
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
                
                const SizedBox(height: 20),

                // Register Button with loading state
                Consumer<UserProvider>(
                  builder: (context, provider, child) {
                    return ElevatedButton(
                      onPressed: provider.isLoading ? null : _handleRegistration,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: provider.isLoading 
                        ? const SizedBox(
                            height: 20, 
                            width: 20, 
                            child: CircularProgressIndicator()
                          )
                        : const Text('Register', style: TextStyle(fontSize: 18)),
                    );
                  },
                ),

                // Login redirect
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<ActionDispatcher>(
                        builder: (context) => const LoginPage(),
                      ),
                    ),
                    child: const Text('Already have an account? Log in'),
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