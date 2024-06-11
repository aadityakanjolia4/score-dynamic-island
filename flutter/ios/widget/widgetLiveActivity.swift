//
//  widgetLiveActivity.swift
//  widget
//
//  Created by Aaditya Kanjolia on 18/05/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct widgetAttributes: ActivityAttributes {
    public typealias stopwatchStatus = ContentState

    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        
       var currentscore:String
       var team1Name: String
       var team2Name: String
       var wkts : String
    }

    // Fixed non-changing properties about your activity go here!
    // var name: String
}

struct widgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: widgetAttributes.self) { context in
            // Lock screen/banner UI
            HStack {
                Text(context.state.team1Name)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
                
            }
            .padding(.horizontal)
            .activityBackgroundTint(Color.black.opacity(0.5))
        }dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.center) {
                    VStack(alignment: .center) {
                        Text("StopWatchX")
                        Spacer().frame(height: 24)
                        HStack {
                            Text(context.state.team2Name)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                           
                            Spacer().frame(width: 10)
                            Text(context.state.team1Name)
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.yellow)
                        }.padding(.horizontal)
                    }
                }
            } compactLeading: {
                Text(context.state.currentscore).foregroundColor(.yellow)
                    .padding(.trailing, 4)
            } compactTrailing: {
                Text(context.state.wkts).foregroundColor(.yellow)
                    .padding(.trailing, 4)
            } minimal: {
                Text(context.state.team1Name)
                    .foregroundColor(.yellow)
                    .padding(.all, 4)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}    


















//                 VStack(alignment: .leading) {
//                     Text(context.state.team1Name)
//                         .font(.system(size: 20, weight: .semibold))
//                         .foregroundColor(.white)
//                     Text(context.state.team2Name)
//                         .font(.system(size: 20, weight: .semibold))
//                         .foregroundColor(.white)
//                 }
//                 Spacer()
//                 VStack(alignment: .trailing) {
//                     Text("Score: \(context.state.currentscore)")
//                         .font(.system(size: 24, weight: .semibold))
//                         .foregroundColor(.yellow)
//                     Text("Wickets: \(context.state.wkts)")
//                         .font(.system(size: 24, weight: .semibold))
//                         .foregroundColor(.yellow)
//                 }
//             }
//             .padding(.horizontal)
//             .activityBackgroundTint(Color.black.opacity(0.5))
//         } dynamicIsland: { context in
//             DynamicIsland {
//                 // Expanded UI
//                 DynamicIslandExpandedRegion(.center) {
//                     VStack(alignment: .center) {
//                         Text("Cricket Match")
//                             .font(.system(size: 24, weight: .bold))
//                             .foregroundColor(.white)
//                         Spacer().frame(height: 24)
//                         HStack {
//                             VStack(alignment: .leading) {
//                                 Text(context.state.team1Name)
//                                     .font(.system(size: 20, weight: .semibold))
//                                     .foregroundColor(.white)
//                                 Text(context.state.team2Name)
//                                     .font(.system(size: 20, weight: .semibold))
//                                     .foregroundColor(.white)
//                             }
//                             Spacer()
//                             VStack(alignment: .trailing) {
//                                 Text("Score: \(context.state.currentscore)")
//                                     .font(.system(size: 24, weight: .semibold))
//                                     .foregroundColor(.yellow)
//                                 Text("Wickets: \(context.state.wkts)")
//                                     .font(.system(size: 24, weight: .semibold))
//                                     .foregroundColor(.yellow)
//                             }
//                         }.padding(.horizontal)
//                     }
//                 }
//             } compactLeading: {
//                 Text("\(context.state.currentscore)")
//                     .font(.system(size: 14, weight: .semibold))
//                     .foregroundColor(.yellow)
//                     .padding(.leading, 4)
//             } compactTrailing: {
//                 Text("\(context.state.wkts)")
//                     .font(.system(size: 14, weight: .semibold))
//                     .foregroundColor(.yellow)
//                     .padding(.trailing, 4)
//             } minimal: {
//                 VStack {
//                     Text("Score: \(context.state.currentscore)")
//                         .font(.system(size: 14, weight: .semibold))
//                         .foregroundColor(.yellow)
//                     Text("Wickets: \(context.state.wkts)")
//                         .font(.system(size: 14, weight: .semibold))
//                         .foregroundColor(.yellow)
//                 }
//             }
//             .widgetURL(URL(string: "http://www.apple.com"))
//             .keylineTint(Color.red)
//         }
//     }
// }

// struct widgetLiveActivity_Previews: PreviewProvider {
    
//     static let attributes = widgetAttributes()
//     static let contentState = widgetAttributes.ContentState(
//         currentscore: "232",
//         team1Name: "Team A",
//         team2Name: "Team B",
//         wkts: "3"
//     )

//     static var previews: some View {
//         Group {
//             attributes
//                 .previewContext(contentState, viewKind: .dynamicIsland(.compact))
//                 .previewDisplayName("Island Compact")
//             attributes
//                 .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
//                 .previewDisplayName("Island Expanded")
//             attributes
//                 .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
//                 .previewDisplayName("Minimal")
//             attributes
//                 .previewContext(contentState, viewKind: .content)
//                 .previewDisplayName("Notification")
//         }
//     }
// }
