import 'package:event_management_app/auth.dart';
import 'package:event_management_app/constants/colors.dart';
import 'package:event_management_app/containers/custom_input.dart';
import 'package:event_management_app/views/login.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _nameController = TextEditingController();
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
          // Sign up form
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Text(
                  "Sign Up",
                  style: TextStyle(
                    color: kLightGreen,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                CustomInputForm(
                  controller: _nameController,
                  icon: Icons.person_outline,
                  label: "Name",
                  hint: "Enter your Name",
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      createUser(_nameController.text, _emailController.text,
                              _passwordController.text)
                          .then((value) {
                        if (value == "success") {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Account Created")));
                          Future.delayed(
                              Duration(seconds: 2),
                              () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage())));
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(value)));
                        }
                      });
                    },
                    child: Text("Sign Up"),
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
                  onTap: () => Navigator.pop(context),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(
                          color: kLightGreen,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(
                            text: "Login",
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
