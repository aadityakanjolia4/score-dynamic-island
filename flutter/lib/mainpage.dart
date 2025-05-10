import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'package:aj/dynamic_island_manager.dart';
import 'package:aj/dynamic_island_stopwatch_data_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late String team1Name = '';
  late String team2Name = '';
  String showrun = '0';
  String prevWickets = '0';
  late DynamicIslandManager diManager;

  @override
  void initState() {
    super.initState();
    diManager = DynamicIslandManager(channelKey: 'DI');
    _setupFirebaseMessaging();
  }

  void _setupFirebaseMessaging() {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    messaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 Foreground Push Received: ${message.data}');

      if (message.data.isNotEmpty) {
        String? runs = message.data['runs'];
        String? wickets = message.data['wickets'];
        String? team1 = message.data['team1'];
        String? team2 = message.data['team2'];

        setState(() {
          showrun = runs ?? '0';
          prevWickets = wickets ?? '0';
          team1Name = team1 ?? '';
          team2Name = team2 ?? '';
        });

        _startOrUpdateLiveActivity();
      }
    });
  }

  void _startOrUpdateLiveActivity() {
    diManager.startLiveActivity(
      jsonData: DynamicIslandStopwatchDataModel(
        currentscore: showrun,
        team1Name: team1Name,
        team2Name: team2Name,
        wkts: prevWickets,
      ).toMap(),
    );

    // Optional: Keep updating every few seconds (optional, based on your use case)
    Timer.periodic(Duration(seconds: 15), (timer) {
      diManager.updateLiveActivity(
        jsonData: DynamicIslandStopwatchDataModel(
          currentscore: showrun,
          team1Name: team1Name,
          team2Name: team2Name,
          wkts: prevWickets,
        ).toMap(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Score'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Team 1: $team1Name', style: TextStyle(fontSize: 20)),
            Text('Team 2: $team2Name', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Text('Score: $showrun/$prevWickets', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 40),
            Text('Waiting for live push updates...', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
