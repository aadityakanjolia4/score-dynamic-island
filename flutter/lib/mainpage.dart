
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:vibration/vibration.dart'; 

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late StreamController<Map<String, dynamic>> _streamController;
  late String team1Name;
  late String team2Name;
  late Timer timer; 
  late Timer matchIdTimer;// Timer variable declaration
  int counter = 0; // Counter variable
  String prevWickets = '0';
  String currentMatchId = '91564';

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<Map<String, dynamic>>();
    // Start the timer when the widget is initialized
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => _fetchCricketMatch(currentMatchId));
    matchIdTimer = Timer.periodic(Duration(seconds: 100), (Timer t) => _updateMatchId());

    // Fetch match data immediately when the widget is initialized
    _fetchCricketMatch(currentMatchId);
  }

  @override
  void dispose() {
    // Cancel the timer and close the stream controller when the widget is disposed
    timer.cancel();
    _streamController.close();
    super.dispose();
  }

  Future<void> _fetchCricketMatch(String matchId) async {
    final response = await http.get(Uri.parse('https://fetch-api-zeta-mauve.vercel.app/score?id=$matchId'));
    // print('$matchId');
    if (response.statusCode == 200) {
      Map<String, dynamic> matchData = json.decode(response.body);
      // Extract team names
      var titleParts = matchData['title'].split(', ');
      var teamNames = titleParts[0].split(' vs ');
      team1Name = teamNames[0];
      team2Name = teamNames[1];

      // Add match data to the stream
      _streamController.add(matchData);
        var score = matchData['livescore'].split('/');
        if(score.contains('/')){
        List<String> parts = score;
        String runs = parts[0];
        String wkts = parts[1];
        List<String> secondPartParts = wkts.split(' ');
        List<String> firstPartParts = runs.split(' ');
        String wickets = secondPartParts[0];
        String run = firstPartParts[1];
        if (int.parse(wickets) > int.parse(prevWickets)) {
          Vibration.vibrate(); // Vibrate the phone
          prevWickets = wickets;
          run=run;
        }
      } 

    } else {
      throw Exception('Failed to load cricket match');
    }
  }
Future<void> _updateMatchId() async {
  final response = await http.get(
    Uri.parse('https://update-matchid.vercel.app/current_match_id'), // Replace with the correct IP address
  );
  
  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    final currentMatchId = responseData['current_match_id'];
    print('$currentMatchId');

    print('Match ID updated successfully');
    setState(() {
      this.currentMatchId = currentMatchId;
    });
    _fetchCricketMatch(currentMatchId); // Fetch data from new matchId
  } else {
    print('Failed to update match ID: ${response.reasonPhrase}');
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text(
          "Live Scores",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // Handle login button press
            },
            child: Text(
              'Login',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: StreamBuilder<Map<String, dynamic>>(
            stream: _streamController.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else if (snapshot.hasData && snapshot.data != null) {
                var matchData = snapshot.data!;
                // Extract team names
                var titleParts = matchData['title'].split(', ');
                var teamNames = titleParts[0].split(' vs ');
                print('teamNames');
                // print('$matchData');
                team1Name = teamNames[0];
                team2Name = teamNames[1];
                var score = matchData['livescore'].split('/');
                if(score.contains('/')){
                List<String> parts = score;
                String runs = parts[0];
                String wkts = parts[1];
                List<String> secondPartParts = wkts.split(' ');
                String wickets = secondPartParts[0];
                }
                // print('$wickets');

                String team1Asset = team1Name.replaceAll(' ', '') + '.png';
                String team2Asset = team2Name.replaceAll(' ', '') + '.png';
                

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        team1Name,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      SizedBox(height: 8),
                                      Image.asset(
                                        'images/$team1Asset',
                                        width: 100,
                                        height: 100,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        team2Name,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      SizedBox(height: 8),
                                      Image.asset(
                                        'images/$team2Asset',
                                        width: 100,
                                        height: 100,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Text(
                                matchData['update'] ?? 'Update Not Found',
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                              SizedBox(height: 20),
                              Text(
                                matchData['livescore'] ?? 'Live Score Not Found',
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Counter: $counter', // Display the counter value
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Text('No match data available');
              }
            },
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MainPage(),
  ));
}



