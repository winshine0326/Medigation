import Flutter
import UIKit
// TODO: Google Maps API 키 설정 후 아래 주석 해제
// import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // TODO: Google Maps API 키 설정 후 아래 주석 해제
    // GMSServices.provideAPIKey("YOUR_API_KEY")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
