import ActivityKit
import WidgetKit
import SwiftUI

struct widgetAttributes: ActivityAttributes {
    public typealias stopwatchStatus = ContentState

    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var currentscore: String
        var team1Name: String
        var team2Name: String
        var wkts: String
    }

    // Fixed non-changing properties about your activity go here!
    // var name: String
}

struct widgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: widgetAttributes.self) { context in
            // Lock screen/banner UI
            HStack {
                Text("Current time elapsed")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal)
            .activityBackgroundTint(Color.black.opacity(0.5))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        Image(context.attributes.team1Name)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .contentTransition(.identity)
                        
                        Text(context.attributes.team1Name)
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    HStack {
                        Image(context.attributes.team2Name)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .contentTransition(.identity)
                        
                        Text(context.attributes.team2Name)
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    VStack {
                        Text("Score: \(context.state.currentscore)")
                        Text("Wickets: \(context.state.wkts)")
                    }
                }
            } compactLeading: {
                Text(context.state.currentscore)
                    .fontWeight(.semibold)
            } compactTrailing: {
                Text(context.state.wkts)
                    .fontWeight(.semibold)
            } minimal: {
                Text("K").foregroundColor(.yellow)
                    .padding(.all, 4)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}
