import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  private let liveActivityManager: LiveActivityManager = LiveActivityManager()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

      self.window = UIWindow(frame: UIScreen.main.bounds)
          let flutterViewController = FlutterViewController()
          self.window?.rootViewController = flutterViewController
          self.window?.makeKeyAndVisible()
      let diChannel = FlutterMethodChannel(name: "DI", binaryMessenger: flutterViewController.binaryMessenger)


    diChannel.setMethodCallHandler({ [weak self] (
           call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                switch call.method {
                case "startLiveActivity":
                    self?.liveActivityManager.startLiveActivity(
                        data: call.arguments as? Dictionary<String,Any>,
                        result: result)
                    break
                    
                case "updateLiveActivity":
                    self?.liveActivityManager.updateLiveActivity(
                        data: call.arguments as? Dictionary<String,Any>,
                        result: result)
                    break
                    
                case "stopLiveActivity":
                    self?.liveActivityManager.stopLiveActivity(result: result)
                    break
                    
                default:
                    result(FlutterMethodNotImplemented)
            }
       })


    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
