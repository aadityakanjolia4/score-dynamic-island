class DynamicIslandStopwatchDataModel {
  // final int elapsedSeconds;
  final String currentscore;
  final String team1Name;
  final String team2Name;
  final String wkts;

  DynamicIslandStopwatchDataModel({
    required this.currentscore,
    required this.team1Name,
    required this.team2Name,
    required this.wkts,

  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'elapsedSeconds': elapsedSeconds,
      'currentscore':currentscore,
      'team1Name':team1Name,
      'team2Name':team2Name,
      'wkts':wkts,
    };
  }
}