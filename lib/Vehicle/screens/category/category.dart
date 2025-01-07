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
                  ),   SizedBox(height: 4),
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
                  // CircleAvatar(child: Image.network(vehicle.vehicleImage,fit: BoxFit.scaleDown,)),
                  Text(
                    'image: ${vehicle.vehicleImage}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                
                 
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        // Edit vehicle logic here
                        print('Edit vehicle ${vehicle.id}');
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Delete vehicle logic here
                        print('Delete vehicle ${vehicle.id}');
                      },
                    ),
                  ),
                ],
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
}
