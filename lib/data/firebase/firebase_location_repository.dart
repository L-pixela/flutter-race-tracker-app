import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:race_tracker_project/data/dto/location_dto.dart';
import 'package:race_tracker_project/data/repository/location_repository.dart';
import 'package:race_tracker_project/model/race/location.dart';

class FirebaseLocationRepository implements LocationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'locations';

  @override
  Future<void> addLocation(Location location) {
    try {
      final locationJson = LocationDto.toJson(location);
      return _firestore
          .collection(_collection)
          .doc(location.name)
          .set(locationJson);
    } catch (e) {
      throw Exception('Failed to add location: $e');
    }
  }

  @override
  Future<List<Location>> getAllLocations() {
    try {
      return _firestore.collection(_collection).get().then((snapshot) {
        return snapshot.docs
            .map((doc) => LocationDto.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      throw Exception('Failed to fetch locations: $e');
    }
  }
}
