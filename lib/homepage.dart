import 'package:flutter/material.dart';
import 'package:flutter_supabase/add_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final SupabaseClient supabase = Supabase.instance.client;

    @override
  void initState() {
    super.initState();
   
    fetchData(); // Initial data fetch
  }


  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      // Fetch data from the 'user_information' table
     final data = await supabase
  .from('user_information')
  .select();
      return List<Map<String, dynamic>>.from(data as List);
    } catch (e) {
      print('Error fetching data: $e');
      rethrow;  // Propagate the error
    }
  }

  Future<void> deleteData(int id) async {
    try {
      // Fetch data from the 'user_information' table
     await supabase
  .from('user_information')
  .delete()
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
        title: const Text('Home Page'),
            actions: <Widget>[
    IconButton(
      icon: Icon(
        Icons.add,
        color: Colors.black,
      ),
      onPressed: () async {
       Navigator.push(
    context,
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
  future: fetchData(), // Fetch data when the FutureBuilder is built
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return Center(child: Text(snapshot.error.toString()));  // Show error
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text('No data available.'));
    }

    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        var data = snapshot.data![index];
        
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                      data['id'].toString() ?? 'No ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
    MaterialPageRoute(builder: (context) => CreateDataScreen(id: data['id'])),
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
                       deleteData( data['id']);
                         fetchData();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  },
)
    );
  }
}
