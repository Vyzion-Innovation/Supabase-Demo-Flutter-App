import 'package:flutter/material.dart';
import 'package:flutter_supabase/Vehicle/screens/vehicle/vehicle_model_class.dart';

class AddVehicleScreen extends StatefulWidget {
  Vehicle? data;

  AddVehicleScreen({super.key, this.data});

  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleCompanyController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _vehicleOwnerController = TextEditingController();
  final _vehicleLicesnsePlateController = TextEditingController();
  final _vehicleColorController = TextEditingController();
  final _vehicleYearofregController = TextEditingController();
  Vehicle? vehicleData;
  bool isForEdit = false;

  // Add other controllers for fields
  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      isForEdit = true;
      vehicleData = widget.data!;
      _vehicleCompanyController.text = vehicleData!.vehicleCompany;
      _vehicleModelController.text = vehicleData!.vehicleModel;
      _vehicleOwnerController.text = vehicleData!.vehicleOwner;
      _vehicleLicesnsePlateController.text = vehicleData!.licensePlate;
      _vehicleColorController.text = vehicleData!.vehicleColor;
      _vehicleYearofregController.text = vehicleData!.yearOfReg;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Vehicle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _vehicleCompanyController,
                decoration: InputDecoration(labelText: 'Vehicle Company'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a vehicle company';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _vehicleModelController,
                decoration: InputDecoration(labelText: 'Vehicle Model'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a vehicle model';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _vehicleOwnerController,
                decoration: InputDecoration(labelText: 'Vehicle owner'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a vehicle owner';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _vehicleLicesnsePlateController,
                decoration: InputDecoration(labelText: 'Vehicle license plate'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a vehicle license plate';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _vehicleColorController,
                decoration: InputDecoration(labelText: 'Vehicle color'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a vehicle color';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _vehicleYearofregController,
                decoration: InputDecoration(
                  labelText: 'Vehicle Year of Registration',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly:
                    true, // Make the TextField read-only so users can't type in it
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a vehicle year of registration';
                  }
                  return null;
                },
                onTap: () {
                  // Show the date picker when the field is tapped
                  _selectYearOfReg(context);
                },
              ),
              // Add other fields here...
              Container(
                margin: const EdgeInsets.only(top: 16.0),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    print(isForEdit);
                    if (_formKey.currentState?.validate() ?? false) {
                      Vehicle newVehicle = Vehicle(
                        vehicleCompany: _vehicleCompanyController.text,
                        vehicleModel: _vehicleModelController.text,
                        vehicleOwner: _vehicleOwnerController.text,
                        licensePlate:
                            _vehicleLicesnsePlateController.text.toUpperCase(),
                        vehicleColor: _vehicleColorController.text,
                        yearOfReg: _vehicleYearofregController.text,
                        // Add other fields...
                      );
                      isForEdit
                          ? Vehicle.updateVehicle(vehicleData?.id, newVehicle)
                          : Vehicle.insertVehicle(newVehicle);
                      Navigator.pop(context, true);
                    }
                  },
                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectYearOfReg(BuildContext context) async {
    // Show the date picker
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Default to the current date
      firstDate: DateTime(1900), // Set a reasonable start year
      lastDate: DateTime.now(), // No future dates allowed
    );

    if (selectedDate != null && selectedDate != DateTime.now()) {
      // If the user selects a date, format it as a string and set it in the controller
      setState(() {
        _vehicleYearofregController.text =
            "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }
}
