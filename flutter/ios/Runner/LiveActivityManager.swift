import ActivityKit
import Flutter
import Foundation

class LiveActivityManager {

  private var DIwidget: Activity<widgetAttributes>? = nil

  func startLiveActivity(data: [String: Any]?, result: FlutterResult) {
    print("Attempting to start live activity...")
    let attributes = widgetAttributes()
        print("widgetAttributes initialized.")

    
    if let info = data as? [String: Any] {
      let state = widgetAttributes.ContentState(
        currentscore: info["currentscore"] as? String ?? "C",
        team1Name: info["team1Name"] as? String ?? "A",
        team2Name: info["team2Name"] as? String ?? "B",
        wkts: info["wkts"] as? String ?? "D"
      )
       print("currentscore: \(currentscore)")
      print("team1Name: \(team1Name)")
      print("team2Name: \(team2Name)")
      print("wkts: \(wkts)")
      
      DIwidget = try? Activity<widgetAttributes>.request(
        attributes: attributes, contentState: state, pushType: nil)
      if DIwidget != nil {
        print("Live activity started successfully.")
      } else {
        print("Failed to start live activity.")
        result(FlutterError(code: "418", message: "Live activity didn't invoke", details: nil))
      }
    } else {
      print("Invalid data received for starting live activity.")
      result(FlutterError(code: "418", message: "Live activity didn't invoke", details: nil))
    }
  }

  func updateLiveActivity(data: [String: Any]?, result: FlutterResult) {
    print("Attempting to update live activity...")
    if let info = data as? [String: Any] {
      let updatedState = widgetAttributes.ContentState(
        currentscore: info["currentscore"] as? String ?? "CC",
        team1Name: info["team1Name"] as? String ?? "AA",
        team2Name: info["team2Name"] as? String ?? "BB",
        wkts: info["wkts"] as? String ?? "DD"
      )
       print("currentscore: \(updatedState.currentscore)")
      print("team1Name: \(updatedState.team1Name)")
      print("team2Name: \(updatedState.team2Name)")
      print("wkts: \(updatedState.wkts)")

      Task {
        await DIwidget?.update(using: updatedState)
        print("Live activity updated successfully.")
      }
    } else {
      print("Invalid data received for updating live activity.")
      result(FlutterError(code: "418", message: "Live activity didn't update", details: nil))
    }
  }

  func stopLiveActivity(result: FlutterResult) {
    print("Attempting to stop live activity...")
    Task {
      await DIwidget?.end(using: nil, dismissalPolicy: .immediate)
      print("Live activity stopped successfully.")
    }
  }
}
