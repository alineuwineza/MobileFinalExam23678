import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GeofencingScreen extends StatefulWidget {
  @override
  _GeofencingScreenState createState() => _GeofencingScreenState();
}

class _GeofencingScreenState extends State<GeofencingScreen> {
  late Position _currentPosition;
  bool _isInsideGeofence = false;

  @override
  void initState() {
    super.initState();
    _initGeofencing();
  }

  void _initGeofencing() async {
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
        _checkGeofence(position);
      });
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  void _checkGeofence(Position position) {
    // Example: Check if position is within a specified geographical boundary
    double latitude = position.latitude;
    double longitude = position.longitude;

    // Define the geographical boundaries (latitude and longitude ranges)
    double minLatitude = 37.42;
    double maxLatitude = 37.43;
    double minLongitude = -122.085;
    double maxLongitude = -122.083;

    // Check if the current position is within the specified boundaries
    if (latitude >= minLatitude &&
        latitude <= maxLatitude &&
        longitude >= minLongitude &&
        longitude <= maxLongitude) {
      setState(() {
        _isInsideGeofence = true;
      });
    } else {
      setState(() {
        _isInsideGeofence = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geofencing'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Current Location: ${_currentPosition.latitude}, ${_currentPosition.longitude}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              _isInsideGeofence ? 'Inside Geofence' : 'Outside Geofence',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
