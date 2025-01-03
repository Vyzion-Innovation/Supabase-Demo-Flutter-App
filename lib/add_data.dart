import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateDataScreen extends StatefulWidget {
  int? id;

  CreateDataScreen({super.key, this.id});
  @override
  _CreateDataScreenState createState() => _CreateDataScreenState();
}

class _CreateDataScreenState extends State<CreateDataScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool isForEdit = false;
  var id ;
  
 @override
  void initState() {
    super.initState();
   isForEdit = widget.id != null ? true : false;
  
   
  id = widget.id;
   
   
  }
  bool _isProcessing = false;
  String _statusMessage = "";

  // Function to insert data into Supabase
 final SupabaseClient supabase = Supabase.instance.client;
  Future insertData() async {
    setState(() {
      _isProcessing = true;
    });
    try {
     
      await supabase
          .from('user_information')
          .insert({'email': _emailController.text, 'name': _nameController.text});
             print(" inserting Data done:  ");
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

 Future<void> editData(int id) async {
    try {
      // Fetch d
      //ata from the 'user_information' table
       if (widget.id == null) {
      throw Exception('ID cannot be null');
    }
     await supabase
  .from('user_information')
  .update({'email': _emailController.text, 'name': _nameController.text})
  .eq('id', id);

       
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
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
        
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isProcessing ? null : insertData,
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
