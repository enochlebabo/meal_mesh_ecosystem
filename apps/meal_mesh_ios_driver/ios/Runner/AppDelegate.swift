import UIKit
import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let keysChannel = FlutterMethodChannel(name: "com.mealmesh.driver/keys",
                                              binaryMessenger: controller.binaryMessenger)
    
    // Listen for the API Key from Dart
    keysChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if (call.method == "provideApiKey") {
        if let args = call.arguments as? [String: Any],
           let apiKey = args["googleMapsKey"] as? String {
            GMSServices.provideAPIKey(apiKey)
            result(true)
        } else {
            result(false)
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
