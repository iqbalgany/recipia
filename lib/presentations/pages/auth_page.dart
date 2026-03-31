import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipia/presentations/cubits/auth/auth_cubit.dart';
import 'package:recipia/presentations/widgets/my_text_form_field.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController fullNameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Error'),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state.status == AuthStatus.authenticated) {
          emailController.clear();
          passwordController.clear();
          fullNameController.clear();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/auth_background.jpg',
                  fit: BoxFit.cover,
                  height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                ),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, authState) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 50,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isLogin ? 'Welcome\nBack' : 'Create\nAccount!',
                            style: TextStyle(
                              fontSize: 35,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 100),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!_isLogin) ...{
                                  // Name Text Field
                                  Text(
                                    'Name',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  MyTextFormField(
                                    hintText: 'Enter Name',
                                    controller: fullNameController,
                                    icon: Icons.person,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your full name';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 10),
                                },

                                // Email Text Field
                                Text(
                                  'Email',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                MyTextFormField(
                                  hintText: 'Enter Email',
                                  controller: emailController,
                                  icon: Icons.email,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Email cannot be empty';
                                    }

                                    final emailRegex = RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                    );
                                    if (!emailRegex.hasMatch(value)) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10),

                                // Password Text Field
                                Text(
                                  'Password',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                MyTextFormField(
                                  hintText: 'Enter Password',
                                  controller: passwordController,
                                  icon: Icons.password,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password cannot be empty';
                                    }
                                    if (value.length < 6) {
                                      return 'Password must be at least 6 characters long';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 50),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Next',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (authState.status == AuthStatus.loading)
                                  Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                else
                                  IconButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        if (!_isLogin) {
                                          context.read<AuthCubit>().register(
                                            emailController.text.trim(),
                                            passwordController.text.trim(),
                                            fullNameController.text.trim(),
                                          );
                                        } else {
                                          context.read<AuthCubit>().login(
                                            emailController.text.trim(),
                                            passwordController.text.trim(),
                                          );
                                        }
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                        Colors.blue,
                                      ),
                                      iconSize: WidgetStatePropertyAll(50),
                                    ),
                                    icon: Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: 50),

                          // login now
                          Center(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: _isLogin
                                        ? 'Don\'t have an account?'
                                        : 'Already have an account?',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  TextSpan(
                                    text: _isLogin ? ' Register' : ' Login',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        setState(() {
                                          _isLogin = !_isLogin;

                                          emailController.clear();
                                          passwordController.clear();
                                          fullNameController.clear();
                                        });
                                      },
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
