import 'package:supabase_flutter/supabase_flutter.dart';

class VehicleCategory {
  int? id;
  final String vehicleName;
  final String vehicleCategory;
  final String description;
  final String vehicleImage;
   final int vehiclePrice;

  VehicleCategory({
    this.id,
    required this.vehicleName,
    required this.vehicleCategory,
    required this.description,
    required this.vehicleImage,
     required this.vehiclePrice,
  });

  Map<String, dynamic> toMap() {
    return {
           'vehicle_name': vehicleName,
      'vehicle_category': vehicleCategory,
      'description': description,
      'vehicle_image': vehicleImage,
      'vechile_price': vehiclePrice,
    };
  }

  static VehicleCategory fromMap(Map<String, dynamic> map) {
    return VehicleCategory(
      id: map['id'],
      vehicleName: map['vehicle_name'],
      vehicleCategory: map['vehicle_category'],
      description: map['description'],
      vehicleImage: map['vehicle_image'],
       vehiclePrice: map['vechile_price'],
    );
  }

  static Future<List<VehicleCategory>> fetchAllCategories() async {
    final response = await Supabase.instance.client
        .from('vehicle_category')
        .select();

    // if (response.error != null) {
    //   throw Exception('Failed to fetch vehicle categories');
    // }

    final List categories = response as List;
    return categories.map((category) => VehicleCategory.fromMap(category)).toList();
  }

  static Future<void> insertCategory(VehicleCategory category) async {
    final response = await Supabase.instance.client
        .from('vehicle_category')
        .insert(category.toMap());

    // if (response.error != null) {
    //   throw Exception('Failed to insert vehicle category');
    // }
  }

  static Future<void> updateCategory(int id, VehicleCategory category) async {
    final response = await Supabase.instance.client
        .from('vehicle_category')
        .update(category.toMap())
        .eq('id', id);

    if (response.error != null) {
      throw Exception('Failed to update vehicle category');
    }
  }

  static Future<void> deleteCategory(int id) async {
    final response = await Supabase.instance.client
        .from('vehicle_category')
        .delete()
        .eq('id', id);

    if (response.error != null) {
      throw Exception('Failed to delete vehicle category');
    }
  }
}
