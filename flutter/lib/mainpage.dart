import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:aj/dynamic_island_manager.dart';
import 'package:aj/dynamic_island_stopwatch_data_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late StreamController<Map<String, dynamic>> _streamController;
  late String team1Name;
  late String team2Name;
  late Timer timer;
  late Timer matchIdTimer;
  int counter = 0;
  String prevWickets = '0';
  String currentMatchId = '91564';
  String showrun = '0';

  // Custom colors for UI enhancement
  final Color primaryColor = const Color(0xFF1A237E); // Deep Indigo
  final Color accentColor = const Color(0xFFFFC107); // Amber
  final Color backgroundColor = const Color(0xFFF5F5F5); // Light Grey
  final Color cardColor = Colors.white;
  final Color textColor = const Color(0xFF212121); // Dark Grey

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<Map<String, dynamic>>();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => _fetchCricketMatch(currentMatchId));
    matchIdTimer = Timer.periodic(Duration(seconds: 10), (Timer t) => _updateMatchId());
    _fetchCricketMatch(currentMatchId);
  }

  @override
  void dispose() {
    timer.cancel();
    matchIdTimer.cancel();
    _streamController.close();
    super.dispose();
  }

  Future<void> _fetchCricketMatch(String matchId) async {
    final response = await http.get(Uri.parse('https://fetch-api-zeta-mauve.vercel.app/score?id=$matchId'));
    if (response.statusCode == 200) {
      Map<String, dynamic> matchData = json.decode(response.body);
      var titleParts = matchData['title'].split(', ');
      var teamNames = titleParts[0].split(' vs ');
      team1Name = teamNames[0];
      team2Name = teamNames[1];

      _streamController.add(matchData);
      var score = matchData['livescore'].split('/');
      if (score.length == 2) {
        List<String> parts = score;
        String runs = parts[0];
        String wkts = parts[1];
        List<String> secondPartParts = wkts.split(' ');
        List<String> firstPartParts = runs.split(' ');
        String wickets = secondPartParts[0];
        String run = firstPartParts[1];
        showrun = run;
        if (int.parse(wickets) > int.parse(prevWickets)) {
          prevWickets = wickets;
        }
      }
    } else {
      throw Exception('Failed to load cricket match');
    }
  }

  Future<void> _updateMatchId() async {
    final response = await http.get(Uri.parse('https://update-matchid.vercel.app/current_match_id'));
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final currentMatchId = responseData['current_match_id'];
      setState(() {
        this.currentMatchId = currentMatchId;
      });
      _fetchCricketMatch(currentMatchId);
    } else {
      print('Failed to update match ID: ${response.reasonPhrase}');
    }
  }

  void activityStart() {
    print("View Score button pressed");
    print(showrun);
    print(prevWickets);
    final DynamicIslandManager diManager = DynamicIslandManager(channelKey: 'DI');
    diManager.startLiveActivity(
      jsonData: DynamicIslandStopwatchDataModel(currentscore: showrun, team1Name: team1Name, team2Name: team2Name, wkts: prevWickets).toMap(),
    );

    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {});
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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          "Live Cricket Scores",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () => _fetchCricketMatch(currentMatchId),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder<Map<String, dynamic>>(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Loading match data...',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.red),
                        SizedBox(height: 16),
                        Text(
                          'Error loading match data',
                          style: TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _fetchCricketMatch(currentMatchId),
                          child: Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasData && snapshot.data != null) {
                  var matchData = snapshot.data!;
                  var titleParts = matchData['title'].split(', ');
                  var teamNames = titleParts[0].split(' vs ');
                  team1Name = teamNames[0];
                  team2Name = teamNames[1];

                  String team1Asset = team1Name.replaceAll(' ', '') + '.png';
                  String team2Asset = team2Name.replaceAll(' ', '') + '.png';

                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: _buildTeamColumn(team1Name, team1Asset),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Text(
                                        'VS',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: accentColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: _buildTeamColumn(team2Name, team2Asset),
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(height: 24),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  matchData['livescore'] ?? 'Live Score Not Found',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  matchData['update'] ?? 'Update Not Found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: textColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              _fetchCricketMatch(currentMatchId).then((_) {
                                activityStart();
                              });
                            },
                            icon: Icon(Icons.sports_cricket),
                            label: Text("View Live Score"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      'No match data available',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamColumn(String teamName, String assetName) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(
            'images/$assetName',
            width: 60,
            height: 60,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.sports_cricket,
                size: 60,
                color: primaryColor,
              );
            },
          ),
        ),
        SizedBox(height: 8),
        Text(
          teamName,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}