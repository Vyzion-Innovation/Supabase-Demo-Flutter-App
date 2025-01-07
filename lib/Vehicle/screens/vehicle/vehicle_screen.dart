import 'package:flutter/material.dart';
import 'package:flutter_supabase/Vehicle/screens/vehicle/add_vehicle_screen.dart';
import 'package:flutter_supabase/Vehicle/screens/vehicle/vehicle_model_class.dart';

class VehicleScreen extends StatefulWidget {
  @override
  _VehicleScreenState createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  List<Vehicle> vehicles = [];
  int currentPage = 0; // Start at the first page
  bool isLoading = false; // Track loading state to prevent multiple API calls
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchVehicles();

    // Detect scroll and load next page when scrolled to the bottom
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadNextPage();
      }
    });
  }

  // Fetch vehicles with pagination support
  Future<void> _fetchVehicles({int page = 0}) async {
    try {
      final fetchedVehicles = await Vehicle.fetchAllVehicles(page);
      setState(() {
        if (page == 0) {
          vehicles = fetchedVehicles; // Reset the list when the first page is fetched
        } else {
          vehicles.addAll(fetchedVehicles); // Add more vehicles to the list when scrolling
        }
      });
    } catch (e) {
      print(e);
    }
  }

  // Fetch the next page
  Future<void> _loadNextPage() async {
    if (isLoading) return; // Prevent loading if already fetching
    setState(() {
      isLoading = true; // Set loading state to true while fetching the next page
    });
    currentPage++;
    await _fetchVehicles(page: currentPage);
    setState(() {
      isLoading = false; // Reset loading state after fetching
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Management'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: vehicles.length + (isLoading ? 1 : 0) , // Add one extra item for loading indicator
        itemBuilder: (context, index) {
          if (index == vehicles.length) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

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
                vehicle.vehicleCompany,
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
                    'Model: ${vehicle.vehicleModel}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Owner: ${vehicle.vehicleOwner}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'License Plate: ${vehicle.licensePlate}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Color: ${vehicle.vehicleColor}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Year of Registration: ${vehicle.yearOfReg}',
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
                      onPressed: () async {
                       final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddVehicleScreen(data: vehicle)),
                          
                        );
                         if (result != null && result == true) {
                            await _fetchVehicles(); // Reload data
                          }
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        print('Delete vehicle ${vehicle.vehicleModel}');
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
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddVehicleScreen()),
          );

          // If the result is not null, reload the vehicle data
          if (result != null && result == true) {
            await _fetchVehicles(); // Reload data
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
