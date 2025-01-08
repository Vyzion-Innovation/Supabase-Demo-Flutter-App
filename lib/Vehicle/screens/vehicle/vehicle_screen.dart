import 'package:flutter/material.dart';
import 'package:flutter_supabase/Vehicle/screens/vehicle/add_vehicle_screen.dart';
import 'package:flutter_supabase/Vehicle/screens/vehicle/vehicle_model_class.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VehicleScreen extends StatefulWidget {
  @override
  _VehicleScreenState createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  List<Vehicle> vehicles = [];
  int currentPage = 0;
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();
  TextEditingController _searchController = TextEditingController(); // Search text controller

  @override
  void initState() {
    super.initState();
    _fetchVehicles(); // Initial fetch

    _searchController.addListener(() {
      final query = _searchController.text;
      searchVehicles(query); // Trigger search on text change
      setState(() {});
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadNextPage();
      }
    });  
  }

  // Search vehicles in the Supabase database
  Future<void> searchVehicles(String query) async {
  if (query.isEmpty) {
    // If no query, fetch all vehicles or reset the list
    await _fetchVehicles(); // Fetch all vehicles again
    return;
  }

  try {
    final response = await Supabase.instance.client
        .from('vehicle') // Ensure the table name is correct
        .select()
        .or('vehicle_company.ilike.%$query%,vehicle_model.ilike.%$query%,vehicle_model.ilike.%$query%'); // Search in vehicle_company column

  
    final List<dynamic> data = response;
    setState(() {
      vehicles = data.map((e) => Vehicle.fromMap(e)).toList(); // Update the vehicle list with search results
    });
  } catch (e) {
    print('Error during search: $e');
  }
}

  @override
  void dispose() {
    _searchController.dispose(); // Dispose the controller
    super.dispose();
  }

  // Fetch vehicles function (unchanged)
  Future<void> _fetchVehicles({int page = 0}) async {
    try {
      final fetchedVehicles = await Vehicle.fetchAllVehicles(page);
      setState(() {
        if (page == 0) {
          vehicles = fetchedVehicles;
        } else {
          vehicles.addAll(fetchedVehicles);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  // Fetch next page (unchanged)
  Future<void> _loadNextPage() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    currentPage++;
    await _fetchVehicles(page: currentPage);
    setState(() {
      isLoading = false;
    });
  }

  @override
 Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Vehicle Management'),
    
    ),
   body: Column(
      children: [
        // Search Bar placed under the title
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Container(
            width: double.infinity, // Take full width
            child: TextField(
              controller: _searchController, // Connect to the search controller
              decoration: InputDecoration(
                hintText: 'Search vehicles...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 245, 241, 241), // Custom color
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear,color: Colors.black12,),
                        onPressed: () {
                          setState(() {
                            _searchController.clear(); // Clear the search field
                            searchVehicles(""); // Reset search query
                          });
                        },
                      )
                    : null, // Show clear icon only if text exists
              ),
              onChanged: (value) {
                searchVehicles(value); // Trigger search when text changes
              },
              textInputAction: TextInputAction.search,
            ),
          ),
        ),
        // ListView or other content g
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: vehicles.length + (isLoading ? 1 : 0),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Text('Model: ${vehicle.vehicleModel}', style: TextStyle(fontSize: 16, color: Colors.black87)),
                      SizedBox(height: 4),
                      Text('Owner: ${vehicle.vehicleOwner}', style: TextStyle(fontSize: 14, color: Colors.black54)),
                      SizedBox(height: 4),
                      Text('License Plate: ${vehicle.licensePlate}', style: TextStyle(fontSize: 14, color: Colors.black54)),
                      SizedBox(height: 4),
                      Text('Color: ${vehicle.vehicleColor}', style: TextStyle(fontSize: 14, color: Colors.black54)),
                      SizedBox(height: 4),
                      Text('Year of Registration: ${vehicle.yearOfReg}', style: TextStyle(fontSize: 14, color: Colors.black54)),
                    ],
                  ),
                  trailing: SizedBox(
                    width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddVehicleScreen(data: vehicle)),
                              );
                              if (result != null && result == true) {
                                await _fetchVehicles(); // Reload data
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(Icons.edit, color: Colors.blue),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              await _showMyDialog(vehicle.id!);
                              await _fetchVehicles();
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(Icons.delete, color: Colors.red),
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
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddVehicleScreen()),
        );
        if (result != null && result == true) {
          await _fetchVehicles(); // Reload data
        }
      },
      child: Icon(Icons.add),
    ),
  );
}


  Future<void> _showMyDialog(int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Do you really want to delete?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                await Vehicle.deleteVehicle(id);
                Navigator.of(context).pop(true);
                await _fetchVehicles(); // Reload data after deletion
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(true); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
 
}

