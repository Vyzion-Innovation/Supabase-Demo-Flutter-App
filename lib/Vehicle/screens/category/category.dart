import 'package:flutter/material.dart';
import 'package:flutter_supabase/Vehicle/screens/category/add_category.dart';
import 'package:flutter_supabase/Vehicle/screens/category/vehicle_category_model.dart';
import 'package:flutter_supabase/Vehicle/screens/vehicle/vehicle_model_class.dart';
// Use this for vehicle category

class VehicleCategoryScreen extends StatefulWidget {
  @override
  _VehicleCategoryScreenState createState() => _VehicleCategoryScreenState();
}

class _VehicleCategoryScreenState extends State<VehicleCategoryScreen> {
  List<VehicleCategory> vehicles = [];

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
  }

  Future<void> _fetchVehicles() async {
    try {
      final fetchedVehicles = await VehicleCategory.fetchAllCategories();
      setState(() {
        vehicles = fetchedVehicles;
      });
    } catch (e) {
      // Handle error
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Management'),
      ),
      body: ListView.builder(
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          final vehicle = vehicles[index];

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(
                vehicle.vehicleName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text(
                    'Name: ${vehicle.vehicleCategory}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'category: ${vehicle.description}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Description: ${vehicle.description.toString()}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Price: ${vehicle.vehiclePrice.toString()}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 4),
                  if (vehicle.vehicleImage != null && vehicle.vehicleImage!.isNotEmpty) ...[
                  CircleAvatar(child: Image.network(vehicle.vehicleImage ?? '',fit: BoxFit.scaleDown,)),
                  ],
                 
                ],
              ),
              trailing: SizedBox(
             
              width: 100,  // Give explicit width to trailing area
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                         final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AddCategoryScreen(data: vehicle)),
                          );
                          if (result != null && result == true) {
                            await _fetchVehicles(); // Reload data
                          }
                        print('Edit vehicle ${vehicle.id}');
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                       await _showMyDialog(vehicle.id!);
                       await _fetchVehicles();
                        print('Delete vehicle ${vehicle.id}');
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCategoryScreen()),
          ).then((value) {
            if (value != null && value == true) {
              // If the result is true, refresh the data
              _fetchVehicles(); // Fetch and update UI
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
  Future<void> _showMyDialog(int id) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Do you really want to delete?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Yes'),
            onPressed: () async {
              // Perform deletion and fetch updated data
              await VehicleCategory.deleteCategory(id);
              Navigator.of(context).pop();
            
            },
          ),
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}
}
