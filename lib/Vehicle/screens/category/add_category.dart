import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_supabase/Vehicle/screens/category/vehicle_category_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddCategoryScreen extends StatefulWidget {
VehicleCategory? data;

  AddCategoryScreen({super.key, this.data});
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
  String? imageUrlStored; // To store the URL of the uploaded image
  bool isForEdit = false;
 VehicleCategory? vehicleData;
 String? imageFileName;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     if (widget.data != null) {
      isForEdit = true;
      vehicleData = widget.data!;
      _vehicleNameController.text = vehicleData!.vehicleName;
      _vehicleCtegoryController.text = vehicleData!.vehicleCategory;
      _vehicleDesccriptionController.text = vehicleData!.description;
     
      _vehiclePriceController.text = vehicleData!.vehiclePrice.toString();
     
    }
  }

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
                  style: TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  pickImage();
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    // First, upload the image to Supabase Storage
                   await uploadOrUpdateImageToSupabase(image, isForEdit: isForEdit);

                    // Proceed with inserting the data into vehicle_category table only if the image upload was successful
                    if (imageUrlStored != null) {
                      VehicleCategory newCategory = VehicleCategory(
                        vehicleName: _vehicleNameController.text,
                        vehicleCategory: _vehicleCtegoryController.text,
                        description: _vehicleDesccriptionController.text,
                        vehicleImage: imageUrlStored ?? '', // Store image URL
                        vehiclePrice:
                            int.tryParse(_vehiclePriceController.text) ?? 0,
                        // Add other fields...
                      );

                      // Insert data into the category table
                        isForEdit ? await VehicleCategory.updateCategory(vehicleData!.id!, newCategory) :
                      await VehicleCategory.insertCategory(newCategory);

                      // Go back to the previous screen (list screen)
                      Navigator.pop(context, true);
                    } else {
// Handle the case where image upload failed
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Image url no found!')),
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
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      setState(() {
        image = File(pickedFile.path); // Store the picked image
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

 Future<void> uploadOrUpdateImageToSupabase(File? imageFile, {bool isForEdit = false}) async {
  if (imageFile == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select an image first.')),
    );
    return;
  }

  try {
    // If uploading for the first time, generate a unique file name
  
      imageFileName = 'vehicle_images/${DateTime.now().millisecondsSinceEpoch.toString()}';
    
    // Perform upload or update based on isForEdit flag
    if (isForEdit) {
      // If editing, first delete the existing file before uploading the new one
      final deleteResult = await Supabase.instance.client.storage
          .from('vehcile_image_file')
          .remove([imageFileName!]);

     

      // Upload the new file after deleting the existing one
      await Supabase.instance.client.storage
          .from('vehcile_image_file')
          .upload(imageFileName!, imageFile);

    } else {
      // If not editing, just upload the file
      await Supabase.instance.client.storage
          .from('vehcile_image_file')
          .upload(imageFileName!, imageFile);
    }

    // Get the public URL for the uploaded or updated image
    final imageUrl = Supabase.instance.client.storage
        .from('vehcile_image_file')
        .getPublicUrl(imageFileName!);

    setState(() {
      imageUrlStored = imageUrl?.toString();
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isForEdit ? 'Image updated successfully!' : 'Image uploaded successfully!')),
    );
  } catch (e) {
    print('Error uploading or updating image: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
}

}
