import 'package:flutter/material.dart';
import 'package:light/light.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LightSensorPage extends StatefulWidget {
  @override
  _LightSensorPageState createState() => _LightSensorPageState();
}

class _LightSensorPageState extends State<LightSensorPage> {
  late Light _light;
  int _luxValue = 0;
  bool _isLightOn = false;
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _light = Light();
    _initLightSensor();
    _initializeNotifications();
  }

  void _initLightSensor() async {
    try {
      _light.lightSensorStream.listen((luxValue) {
        setState(() {
          _luxValue = luxValue.toInt(); // Convert int to double
          _adjustSmartLightBrightness();
        });
      });
    } catch (e) {
      print("Error starting light sensor: $e");
    }
  }

  void _adjustSmartLightBrightness() {
    // Example implementation: Adjust smart light brightness or notify users
    if (_luxValue < 50) {
      // If the light level is below 50 lux, turn on smart lights or notify the user
      if (!_isLightOn) {
        _turnOnSmartLights();
        _isLightOn = true;
      }
      _notifyUser('Low light level detected');
    } else {
      // If the light level is above 50 lux, turn off smart lights or notify the user
      if (_isLightOn) {
        _turnOffSmartLights();
        _isLightOn = false;
      }
      _notifyUser('Sufficient light level detected');
    }
  }

  void _turnOnSmartLights() {
    // Implement code to turn on smart lights
    print('Smart lights turned on');
  }

  void _turnOffSmartLights() {
    // Implement code to turn off smart lights
    print('Smart lights turned off');
  }

  void _notifyUser(String message) {
    // Implement code to notify user (e.g., show a notification)
    print('Notification: $message');
    _showNotification('Light Sensor Notification', message);
  }

  void _initializeNotifications() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(String title, String message) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'light_channel',
      'Light Sensor Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      message,
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ambient Light Sensor'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              _isLightOn ? Icons.lightbulb : Icons.lightbulb_outline,
              size: 100,
              color: _isLightOn ? Colors.yellow : Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              'Lux Value: $_luxValue',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (!_isLightOn) {
                    _turnOnSmartLights();
                    _isLightOn = true;
                  } else {
                    _turnOffSmartLights();
                    _isLightOn = false;
                  }
                });
              },
              child: Text(_isLightOn ? 'Turn Off' : 'Turn On'),
            ),
          ],
        ),
      ),
    );
  }
}
