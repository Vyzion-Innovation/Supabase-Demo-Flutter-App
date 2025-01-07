import 'package:supabase_flutter/supabase_flutter.dart';

class Vehicle {
  int? id;
  final String vehicleCompany;
  final String vehicleModel;
  final String vehicleOwner;
  final String licensePlate;
  final String vehicleColor;
  final String yearOfReg;
  

  Vehicle({
     this.id,
    required this.vehicleCompany,
    required this.vehicleModel,
    required this.vehicleOwner,
    required this.licensePlate,
    required this.vehicleColor,
    required this.yearOfReg,
  });

  Map<String, dynamic> toMap() {
    return {
     
      'vehicle_company': vehicleCompany,
      'vehicle_model': vehicleModel,
      'vehicle_owner': vehicleOwner,
      'license_plate': licensePlate,
      'vehicle_color': vehicleColor,
      'year_of_reg.': yearOfReg,
    };
  }

  static Vehicle fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'],
      vehicleCompany: map['vehicle_company'],
      vehicleModel: map['vehicle_model'],
      vehicleOwner: map['vehicle_owner'],
      licensePlate: map['license_plate'],
      vehicleColor: map['vehicle_color'],
      yearOfReg: map['year_of_reg.'],
    );
  }

  static Future<List<Vehicle>> fetchAllVehicles(int page) async {
  const int limit = 4; // Number of records per page
  final offset = page * limit; // Calculate offset based on the page number

  final response = await Supabase.instance.client
      .from('vehicle')
      .select()
      .range(offset, offset + limit - 1); // Apply range for pagination

  final List vehicles = response as List;
  return vehicles.map((vehicle) => Vehicle.fromMap(vehicle)).toList();
}


  static Future<void> insertVehicle(Vehicle vehicle) async {
    final response = await Supabase.instance.client
        .from('vehicle')
        .insert(vehicle.toMap());
         print(response);

   
  }

  static Future<void> updateVehicle(int? id, Vehicle vehicle) async {
     if (id == null) {
    throw Exception('Vehicle ID cannot be null');
  }
    final response = await Supabase.instance.client
        .from('vehicle')
        .update(vehicle.toMap())
        .eq('id', id);
        print(response);

   
  }

  static Future<void> deleteVehicle(int id) async {
    final response = await Supabase.instance.client
        .from('vehicle')
        .delete()
        .eq('id', id);

    if (response.error != null) {
      throw Exception('Failed to delete vehicle');
    }
  }
}
