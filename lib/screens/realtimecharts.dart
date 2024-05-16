import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(MaterialApp(
    home: RealTimeChartPage(),
  ));
}

class RealTimeChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Real Time Chart'),
      ),
      body: RealTimeChart(),
    );
  }
}

class RealTimeChart extends StatefulWidget {
  @override
  _RealTimeChartState createState() => _RealTimeChartState();
}

class _RealTimeChartState extends State<RealTimeChart> {
  late List<_ChartData> _chartData;
  late Timer _timer;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _chartData = <_ChartData>[];
    _startTimer();
    _initializeNotifications();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _initializeNotifications() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _showNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), _updateData);
  }

  void _updateData(Timer timer) {
    setState(() {
      _chartData.add(_ChartData(DateTime.now(), _getRandomValue()));
      if (_chartData.length > 20) {
        _chartData.removeAt(0);
      }
      if (_chartData.length >= 10 && _chartData.last.y > 80) {
        _showNotification('Alert', 'High sensor reading detected!');
      }
    });
  }

  double _getRandomValue() {
    return (50 + (100 - 50) * (1 - (DateTime.now().second / 60))).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SfCartesianChart(
        primaryXAxis: DateTimeAxis(),
        primaryYAxis: NumericAxis(),
        series: <LineSeries<_ChartData, DateTime>>[
          LineSeries<_ChartData, DateTime>(
            dataSource: _chartData,
            xValueMapper: (_ChartData data, _) => data.time,
            yValueMapper: (_ChartData data, _) => data.y,
          ),
        ],
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.time, this.y);
  final DateTime time;
  final double y;
}
