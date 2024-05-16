import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:sensormobileapplication/components/ThemeProvider.dart';
import 'package:sensormobileapplication/screens/StepCounter.dart';
import 'package:sensormobileapplication/screens/lightsensor.dart';
import 'package:sensormobileapplication/screens/maps.dart';
import 'package:sensormobileapplication/screens/realtimecharts.dart';
import 'package:sensormobileapplication/screens/geofence.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await initNotifications(flutterLocalNotificationsPlugin);
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(
          title: 'Home',
          flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
        ),
      ),
    ),
  );
}

Future<void> initNotifications(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) async {
      // Handle notification tap
    },
  );
}

class MyHomePage extends StatelessWidget {
  final String title;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  const MyHomePage({
    required this.title,
    required this.flutterLocalNotificationsPlugin,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.hintColor,
        title: Text(
          title,
          style: TextStyle(color: theme.primaryColor),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ' Smart Home Monitoring System',
              style: TextStyle(color: theme.hintColor),
            ),
            SizedBox(height: 20),
            _buildButton(
              context,
              icon: Icons.map,
              label: 'Location Tracking',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MapPage(
                    flutterLocalNotificationsPlugin:
                        flutterLocalNotificationsPlugin,
                  ),
                ));
              },
              theme: theme, // Pass theme for consistent color usage
            ),
            _buildButton(
              context,
              icon: Icons.map,
              label: 'Geofence',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GeofencingScreen(
                      //flutterLocalNotificationsPlugin:
                      //  flutterLocalNotificationsPlugin,
                      ),
                ));
              },
              theme: theme, // Pass theme for consistent color usage
            ),
            _buildButton(
              context,
              icon: Icons.run_circle_outlined,
              label: 'Motion Detection',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => StepCounterPage(
                    flutterLocalNotificationsPlugin:
                        flutterLocalNotificationsPlugin,
                  ),
                ));
              },
              theme: theme, // Pass theme for consistent color usage
            ),
            _buildButton(
              context,
              icon: Icons.graphic_eq_rounded,
              label: 'charts graph',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RealTimeChartPage(
                      //flutterLocalNotificationsPlugin:
                      //  flutterLocalNotificationsPlugin,
                      ),
                ));
              },
              theme: theme, // Pass theme for consistent color usage
            ),
            _buildButton(
              context,
              icon: Icons.lightbulb_rounded,
              label: 'Light level sensor',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LightSensorPage(
                        //flutterLocalNotificationsPlugin:
                        //flutterLocalNotificationsPlugin,
                        ),
                  ),
                );
              },
              theme: theme, // Pass theme for consistent color usage
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required ThemeData theme, // Accept theme as a parameter
  }) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(
            255, 24, 23, 23)), // Change text color to white
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              color:
                  Color.fromARGB(255, 30, 29, 29)), // Use white color for icon
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
                color: const Color.fromARGB(
                    255, 18, 17, 17)), // Use white color for text
          ),
        ],
      ),
    );
  }
}
