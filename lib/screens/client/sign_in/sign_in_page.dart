import 'package:ecommerce_app/screens/client/client_home/client_home_screen.dart';
import 'package:ecommerce_app/screens/client/sign_up_screen/sign_up_page.dart';
import 'package:ecommerce_app/style/app_style.dart';
import 'package:ecommerce_app/style/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  late String _email, _password;
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 232, 236, 237),
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(ImageAssets.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 232, 236, 237),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'StyleMySpace',
                      textStyle: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 250,
                  height: 250,
                  child: Image.asset(
                    ImageAssets.welcome,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 30),
                buildEmailField(),
                const SizedBox(height: 20),
                buildPasswordField(),
                const SizedBox(height: 20),
                buildLoginButton(),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()),
                    );
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: 'Create account',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEmailField() {
    return TextFormField(
      style: const TextStyle(color: Colors.black),
      decoration: AppStyles.formStyle(
        context,
        'Email',
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
      onSaved: (value) => _email = value!,
    );
  }

  Widget buildPasswordField() {
    return TextFormField(
      style: const TextStyle(color: Colors.black),
      decoration: AppStyles.formStyle(
        context,
        'Password',
        suffixIcon: IconButton(
          onPressed: () => setState(() => _isHidden = !_isHidden),
          icon: Icon(
            _isHidden ? Icons.visibility : Icons.visibility_off,
            color: Colors.black,
          ),
        ),
      ),
      obscureText: _isHidden,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
      onSaved: (value) => _password = value!,
    );
  }

  Widget buildLoginButton() {
    return SizedBox(
      width: 240,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blueGrey.shade900,
          backgroundColor: const Color(0xFFA95EFA),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Login',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            _login();
          }
        },
      ),
    );
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      //UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login succeeded'),
            backgroundColor: Colors.green,
          ),
        );
      }

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ClientHome()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No user found for that email.'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong password provided for that user.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // End the loading process
        });
      }
    }
  }
}
