import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_supabase/Vehicle/screens/category/vehicle_category_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddCategoryScreen extends StatefulWidget {
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleNameController = TextEditingController();
  final _vehicleCtegoryController = TextEditingController();
  final _vehicleDesccriptionController = TextEditingController();
  final _vehiclePriceController = TextEditingController();
  File? image;
  String? imageUrlStored;  // To store the URL of the uploaded image

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Vehicle Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _vehicleNameController,
                decoration: InputDecoration(labelText: 'Vehicle name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a vehicle name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _vehicleCtegoryController,
                decoration: InputDecoration(labelText: 'Vehicle category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a vehicle category';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _vehicleDesccriptionController,
                decoration: InputDecoration(labelText: 'Vehicle description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a vehicle description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _vehiclePriceController,
                decoration: InputDecoration(labelText: 'Vehicle price'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a vehicle price';
                  }
                  return null;
                },
              ),
              MaterialButton(
                color: Colors.blue,
                child: const Text(
                  "Pick Image from Gallery",
                  style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  pickImage();
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    // First, upload the image to Supabase Storage
                  imageUrlStored =  await uploadImageToSupabase(image!);

                    if (imageUrlStored != null) {
                      // Proceed with inserting the data into vehicle_category table only if the image upload was successful
                      VehicleCategory newCategory = VehicleCategory(
                        vehicleName: _vehicleNameController.text,
                        vehicleCategory: _vehicleCtegoryController.text,
                        description: _vehicleDesccriptionController.text,
                        vehicleImage: imageUrlStored ?? '',  // Store image URL
                        vehiclePrice: int.tryParse(_vehiclePriceController.text) ?? 0,
                        // Add other fields...
                      );

                      // Insert data into the category table
                      await VehicleCategory.insertCategory(newCategory);

                      // Go back to the previous screen (list screen)
                      Navigator.pop(context,true);
                    } else {
                      // Handle the case where the image upload failed
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed to upload image")),
                      );
                    }
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;
      
      setState(() {
        image = File(pickedFile.path);  // Store the picked image
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

 Future<String?> uploadImageToSupabase(File imageFile) async {
  try {
    final fileName = 'vehicle_images/${DateTime.now().millisecondsSinceEpoch}.jpg'; // Create a unique file name
    // final file = File(imageFile.path);

    // Upload the image to Supabase Storage
     await Supabase.instance.client.storage
        .from('vehcile_image_file') // Replace with your storage bucket name
        .upload(fileName, imageFile.path as File);

   
      final imageUrl =  Supabase.instance.client.storage
          .from('vehcile_image_file')
          .getPublicUrl(fileName); // Retrieve public URL
      
      return imageUrl;
 
      // Error uploading the image
     
      
    
  } catch (e) {
    print('Error uploading image: $e');
    return null;
  }
}


}
