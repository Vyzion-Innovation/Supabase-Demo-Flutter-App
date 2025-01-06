import 'package:flutter/material.dart';
import 'package:flutter_supabase/add_data.dart';
import 'package:flutter_supabase/startpage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  {
  final SupabaseClient supabase = Supabase.instance.client;
    List<dynamic> userData = [];

  @override
  void initState() {
    super.initState();

    fetchData(); // Initial data fetch
  }

  Future<void> fetchData() async {
    final user = supabase.auth.currentUser; // Get the logged-in user

  if (user == null) {
    // Handle case where user is not logged in
    print("User not logged in.");
    return;
  }

    try {
      // Fetch data from the 'user_information' table
      final data = await supabase.from('user_information').select().eq('user_id', user.id);
     setState(() {
        userData = List<dynamic>.from(data); // Update the local state
      });
    } catch (e) {
      print('Error fetching data: $e');
      rethrow; // Propagate the error
    }
  }

  Future<void> deleteData(int id) async {
    try {
      // Delete data from the 'user_information' table
      await supabase.from('user_information').delete().eq('id', id);
      // Fetch updated data after deletion and update UI
      await fetchData();
    } catch (e) {
      print('Error deleting data: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
          actions: <Widget>[
             IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ),
              onPressed: () async {
               await supabase.auth.signOut();
                Navigator.of(context).push(
            MaterialPageRoute(
              settings: RouteSettings(name: "/Page1"),
              builder: (context) => StartPage(),
            ),
          );

              },
            ),
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
              onPressed: () async {
               await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CreateDataScreen()),
                ).then((value) {
                  if (value != null && value == true) {
                    // If the result is true, refresh the data
                    fetchData(); // Fetch and update UI
                  }
                });
              },
            )
          ],
        ),
        body: userData.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Loading indicator
          : userData == null
              ? const Center(child: Text('No data available.')) : ListView.builder(
              itemCount: userData.length,
              itemBuilder: (context, index) {
                var data = userData[index];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Column for Name and Email
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            Text(
                              data['name'] ?? 'No name',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              data['email'] ?? 'No email',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              data['phone'].toString() ?? 'No ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              data['pincode'].toString() ?? 'No ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              data['id'].toString() ?? 'No ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        // Column for Icon Buttons (Edit & Delete)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                            onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CreateDataScreen(data: data),
                                    ),
                                  ).then((value) {
                                    if (value != null && value == true) {
                                      // If the result is true, refresh the data
                                      fetchData(); // Fetch and update UI
                                    }
                                  });
                                },

                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _showMyDialog(data['id']);
                                      },                                                          
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            
          
        ));
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
              await deleteData(id);
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
