import 'package:event_management_app/auth.dart';
import 'package:event_management_app/constants/colors.dart';
import 'package:event_management_app/containers/custom_input.dart';
import 'package:event_management_app/views/homepage.dart';
import 'package:event_management_app/views/signup.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.network(
              'https://images.pexels.com/photos/3951652/pexels-photo-3951652.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          // Dark overlay to improve text visibility
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          // Login form
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Text(
                  "Login",
                  style: TextStyle(
                    color: kLightGreen,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                CustomInputForm(
                  controller: _emailController,
                  icon: Icons.email_outlined,
                  label: "Email",
                  hint: "Enter your Email",
                ),
                const SizedBox(height: 16),
                CustomInputForm(
                  obscureText: true,
                  controller: _passwordController,
                  icon: Icons.lock_outline_rounded,
                  label: "Password",
                  hint: "Enter your Password",
                ),
                const SizedBox(height: 8),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     TextButton(
                //       onPressed: () {
                //         // Handle forget password action
                //       },
                //       child: Text(
                //         "Forget Password?",
                //         style: TextStyle(
                //           color: kLightGreen,
                //           fontSize: 16,
                //           fontWeight: FontWeight.w400,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      loginUser(_emailController.text, _passwordController.text)
                          .then((value) {
                        if (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Login Successful !!!")),
                          );

                          Future.delayed(
                            Duration(seconds: 2),
                            () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Homepage()),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Login Failed. Try Again.")),
                          );
                        }
                      });
                    },
                    child: Text("Login"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: kLightGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Signup()),
                  ),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Create a New Account? ",
                        style: TextStyle(
                          color: kLightGreen,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(
                            text: "Sign Up",
                            style: TextStyle(
                              color: kLightGreen,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
