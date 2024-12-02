import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:rivezni/core/providers/auth_provider.dart';
import 'package:rivezni/features/authentication/screens/register.dart';
import 'package:rivezni/features/authentication/widgets/login_form.dart';
import 'package:rivezni/features/home/screens/home.dart';
import 'package:rivezni/shared/widgets/toast.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isSigningIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    setState(() {
      _isSigningIn = true;
    });

      final user = await authProvider.login(_emailController.text, _passwordController.text);


    setState(() {
      _isSigningIn = false;
    });

    if (user != null) {
      showToast(message: "User is successfully logged in");
              Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Home(),
                            ),
                          );
    } else {
      showToast(message: "some error occured");
    }
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }


 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 124, 123, 123),
      body: SafeArea(
        child: Column(
          children: [
            _buildBackButton(),
            const SizedBox(height: 5),
            Lottie.network(
              'https://lottie.host/dee65a23-907f-4fdc-821b-702d69dbd451/pVbPqEZbdj.json',
               height: 200.0,
            ),
            const SizedBox(height: 5),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 194, 194, 194),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Login to your account",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      child: LoginForm(
                        emailController: _emailController,
                        passwordController: _passwordController,
                        isSigningIn: _isSigningIn,
                        onLogin: _signIn,
                        onNavigateToRegister: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Register(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
