import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateDataScreen extends StatefulWidget {
 var data;

  CreateDataScreen({super.key, this.data});
  @override
  _CreateDataScreenState createState() => _CreateDataScreenState();
}

class _CreateDataScreenState extends State<CreateDataScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
   final _userIdController = TextEditingController();
  final _phoneController = TextEditingController();
   final _pinCodeController = TextEditingController();

  bool isForEdit = false;
  var primaryId;
  
 @override
  void initState() {
    super.initState();
   isForEdit = widget.data != null ? true : false;
  
   
    if (isForEdit) {
      primaryId = widget.data['id'];
      _nameController.text = widget.data['name'];
      _emailController.text = widget.data['email'];
      _phoneController.text = widget.data['phone'].toString();
      _pinCodeController.text = widget.data['pincode'].toString();
    } 
   
   
  }
  bool _isProcessing = false;
  String _statusMessage = "";

  // Function to insert data into Supabase
 final SupabaseClient supabase = Supabase.instance.client;
  Future insertData() async {
    setState(() {
      _isProcessing = true;
    });
   

     final user = supabase.auth.currentUser;

     if(user == null){
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('User not found')));
       return;
     }
      try {
      await supabase.from('user_information').insert({
      'user_id': user.id, // Use the logged-in user's ID
      'email': _emailController.text,
      'name': _nameController.text,
      'phone': _phoneController.text,
      'pincode': _pinCodeController.text,
    }).eq('user_id', user.id);
    Navigator.pop(context, true); 

    } catch (e) {
      //print statment for identify insert error in if any , it will print the error in console
      print("Error while inserting Data: $e ");
      setState(() {
        _isProcessing = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Someting went Wrong!')));
    }
  }

 Future editData() async {
    try {
      // Fetch d
      //ata from the 'user_information' table
       if (primaryId == null) {
      throw Exception('ID cannot be null');
    }
     await supabase
  .from('user_information')
  .update({ 'email': _emailController.text,
      'name': _nameController.text,
      'phone': _phoneController.text,
      'pincode': _pinCodeController.text,})
  .eq('id', primaryId); 
  Navigator.pop(context, true); 
    } catch (e) {
      print('Error updating data: $e');
      rethrow;  // Propagate the error

       
    } catch (e) {
      print('Error deleting data: $e');
      rethrow;  // Propagate the error
    }
  }

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
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
              keyboardType: TextInputType.emailAddress,
            ),
              TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
              TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.emailAddress,
            ),
              TextField(
              controller: _pinCodeController,
              decoration: InputDecoration(labelText: 'Pin code'),
              keyboardType: TextInputType.emailAddress,
            ),
        
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isForEdit ? editData : insertData,
              child: _isProcessing
                  ? CircularProgressIndicator()
                  :isForEdit ?  Text('Edit Data') : Text('Add Data'),
            ),
            SizedBox(height: 20),
            Center(child: Text(_statusMessage)),
          ],
        ),
      ),
    );
  }
}
