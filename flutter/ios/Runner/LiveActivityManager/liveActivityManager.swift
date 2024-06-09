////
////  liveActivityManager.swift
////  Runner
////
////  Created by user936100 on 6/8/24.
////
//
//import Foundation
//import ActivityKit
//import Flutter
//import Foundation
//
//class LiveActivityManager {
//
//  private var stopwatchActivity: Activity<widgetAttributes>? = nil
//
//  func startLiveActivity(data: [String: Any]?, result: FlutterResult) {
//    let attributes = widgetAttributes()
//    
//
//    if let info = data as? [String: Any] {
//      let state = widgetAttributes.ContentState(
//        currentscore: info["currentscore"] as? Int ?? 0,
//        team1Name: info["team1Name"] as? String ?? "A",
//        team2Name: info["team2Name"] as? String ?? "B",
//        wkts: info["wkts"] as? Int ?? 0
//        
//      )
//      stopwatchActivity = try? Activity<widgetAttributes>.request(
//        attributes: attributes, contentState: state, pushType: nil)
//    } else {
//      result(FlutterError(code: "418", message: "Live activity didn't invoked", details: nil))
//    }
//  }
//
//func updateLiveActivity(data: [String: Any]?, result: FlutterResult) {
//  if let info = data as? [String: Any] {
//    let updatedState = widgetAttributes.ContentState(
//      currentscore: info["currentscore"] as? Int ?? 0,
//      team1Name: info["team1Name"] as? String ?? "A",
//      team2Name: info["team2Name"] as? String ?? "B",
//      wkts: info["wkts"] as? Int ?? 0
//    )
//
//    Task {
//      await stopwatchActivity?.update(using: updatedState)
//    }
//  } else {
//    result(FlutterError(code: "418", message: "Live activity didn't updated", details: nil))
//  }
//}
//
//func stopLiveActivity(result: FlutterResult) {
//  do {
//    Task {
//      await stopwatchActivity?.end(using: nil, dismissalPolicy: .immediate)
//    }
//  } catch {
//    result(FlutterError(code: "418", message: error.localizedDescription, details: nil))
//  }
//}
//}
///////////////////////////////////////////////////////////////////////////
//
//
////