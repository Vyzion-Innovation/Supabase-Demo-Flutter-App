import 'package:flutter/material.dart';
import 'package:flutter_supabase/Vehicle/screens/category/category.dart';
import 'package:flutter_supabase/Vehicle/screens/vehicle/vehicle_screen.dart';
import 'package:flutter_supabase/startpage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Management'),
          actions: <Widget>[
             IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ),
              onPressed: () async {
               await Supabase.instance.client.auth.signOut();
                Navigator.of(context).push(
            MaterialPageRoute(
              settings: RouteSettings(name: "/Page1"),
              builder: (context) => StartPage(),
            ),
          );

              },
            ),
          ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            // Vehicle Card
            GestureDetector(
              onTap: () {
                // Navigate to the Vehicle Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VehicleScreen()),
                );
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    // Navigate to the vehicle screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VehicleScreen()),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions_car,
                        size: 50,
                        color: Colors.blue,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Vehicles',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Vehicle Category (Details) Card
            GestureDetector(
              onTap: () {
                // Navigate to the Vehicle Category Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VehicleScreen()),
                );
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VehicleCategoryScreen()),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.category,
                        size: 50,
                        color: Colors.green,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Category Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
