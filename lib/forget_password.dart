import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
} 
class _ForgetPasswordState extends State<ForgetPassword>{
   final _emailController = TextEditingController();
   final SupabaseClient supabase = Supabase.instance.client;



  @override
  Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        title: Text('Create Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          
          
              TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            ElevatedButton( onPressed: () { checkEmailAndResetPassword();  
           
            },
            child: Text("Reset Password"),
            ),
        ])
      ));
  }

  bool isEmailisinAuthentic() {
  final email = _emailController.text.trim(); 
  RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegExp.hasMatch(email)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please enter a valid email address"),
        backgroundColor: Colors.red,
      ),
    );
    return false;
  }
  return true;
  }
   Future<void> checkEmailAndResetPassword() async {
  final email = _emailController.text.trim();

  // Check if email is valid (optional but recommended)
  if (!isEmailisinAuthentic()) {
    return;
  }

  try {
    // Attempt to send a password reset email
    final response = await supabase.auth.resetPasswordForEmail(email);

    // If we get a response, we can safely assume the email exists
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Password reset email sent!"),
        backgroundColor: Colors.green,
      ),
    );
     Navigator.pop(context, true);

  } catch (e) {
    // If something went wrong, show the error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error: ${e.toString()}"),
        backgroundColor: Colors.red,
      ),
    );
  }
}
  }


