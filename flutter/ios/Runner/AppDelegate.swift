import UIKit
import Flutter
import Firebase

@main
@objc class AppDelegate: FlutterAppDelegate {

  private let liveActivityManager: LiveActivityManager = LiveActivityManager()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Initialize Firebase
    FirebaseApp.configure()

    GeneratedPluginRegistrant.register(with: self)

    self.window = UIWindow(frame: UIScreen.main.bounds)
    let flutterViewController = FlutterViewController()
    self.window?.rootViewController = flutterViewController
    self.window?.makeKeyAndVisible()

    let diChannel = FlutterMethodChannel(name: "DI", binaryMessenger: flutterViewController.binaryMessenger)

    diChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      switch call.method {
      case "startLiveActivity":
        self?.liveActivityManager.startLiveActivity(
          data: call.arguments as? [String: Any],
          result: result)
      case "updateLiveActivity":
        self?.liveActivityManager.updateLiveActivity(
          data: call.arguments as? [String: Any],
          result: result)
      case "stopLiveActivity":
        self?.liveActivityManager.stopLiveActivity(result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // MARK: - Firebase Notification Handling (only if FirebaseAppDelegateProxyEnabled = NO)

  override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    // Pass device token to Firebase
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    // Handle incoming notification data
    Messaging.messaging().appDidReceiveMessage(userInfo)
    super.application(application, didReceiveRemoteNotification: userInfo)
  }

  override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                             fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    // Handle background notification fetch
    Messaging.messaging().appDidReceiveMessage(userInfo)
    super.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
  }
}
