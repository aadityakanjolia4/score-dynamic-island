import ActivityKit
import Flutter
import Foundation

class LiveActivityManager {

  private var DIwidget: Activity<widgetAttributes>? = nil

  func startLiveActivity(data: [String: Any]?, result: FlutterResult) {
    print("Attempting to start live activity...")
    let attributes = widgetAttributes()
    
    if let info = data as? [String: Any] {
      let state = widgetAttributes.ContentState(
        currentscore: info["currentscore"] as? Int ?? 0,
        team1Name: info["team1Name"] as? String ?? "A",
        team2Name: info["team2Name"] as? String ?? "B",
        wkts: info["wkts"] as? Int ?? 0
      )
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
        currentscore: info["currentscore"] as? Int ?? 0,
        team1Name: info["team1Name"] as? String ?? "A",
        team2Name: info["team2Name"] as? String ?? "B",
        wkts: info["wkts"] as? Int ?? 0
      )

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
