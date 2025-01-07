import 'package:flutter/material.dart';
import 'package:flutter_supabase/forget_password.dart';
import 'package:flutter_supabase/User_information/homepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  bool _signInLoading = false;
  bool _signUpLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(
                20.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipOval(
                    
                    child: Image.network(
                      'https://picsum.photos/id/237/200/300',
                       height: 300.0,  // Increase the height
   
    
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  //Email field
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field is required';
                      }
                      return null;
                    },
                    controller: _emailController,
                    decoration: const InputDecoration(label: Text("Email")),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  //Password field
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field is required';
                      }
                      return null;
                    },
                    controller: _passwordController,
                    decoration: const InputDecoration(label: Text("Password")),
                    obscureText: true,
                  ),
                  TextButton(onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPassword())); },
                  child: Text("Forgot Password")), 
                  const SizedBox(height: 25.0),

                  //Sign In Button
                 _signInLoading
    ? const Center(
        child: CircularProgressIndicator(),
      )
    : ElevatedButton(
        onPressed: () async {
          final isValid = _formKey.currentState?.validate();
          if (isValid != true) {
            return;
          }
          setState(() {
            _signInLoading = true;
          });
          try {
            final response = await supabase.auth.signInWithPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

            if (response.user != null) {
              // Successful sign-in
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Welcome, ${response.user!.email}!"),
                  backgroundColor: Colors.green,
                ),
              );
              // Navigate to HomePage or next screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            } else {
              // Failed sign-in
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Sign-In failed. Please check credentials."),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } catch (e) {
            // Handle unexpected errors
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Error occurred: $e"),
                backgroundColor: Colors.red,
              ),
            );
          }
          setState(() {
            _signInLoading = false;
          });
        },
        child: const Text(
          "Sign In",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
                               //SignUp Button
                  _signInLoading
                      ? const Center(child: CircularProgressIndicator())
                      : OutlinedButton(
                          onPressed: () async {
                            final isValid = _formKey.currentState?.validate();
                            if (isValid != true) {
                              return;
                            }
                            setState(() {
                              _signUpLoading = true;
                            });
                            try {
                              final response = await supabase.auth.signUp(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );

                              if (response.user != null) {
                                // User successfully registered, send success message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Success! Confirmation email sent to ${response.user!.email}"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } else {
                                // If no user was created (indicates an issue), show error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Sign-Up failed. Please try again."),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } catch (e) {
                              // Handle any unexpected errors
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text("Unexpected error occurred: $e"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                            setState(() {
                              _signUpLoading = false;
                            });
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                  const SizedBox(height: 25.0),
                  const Center(
                      child: const Text("Credit: Developed by Code master: Pawan Ginti"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
}
