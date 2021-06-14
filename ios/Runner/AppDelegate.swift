import UIKit
import Flutter
import Firebase
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }
    FirebaseApp.configure()
    BTAppSwitch.setReturnURLScheme("com.app.facesbyplaces.braintree")
    GMSServices.provideAPIKey("AIzaSyDdGbn-l8EjoPZOqQoedcCzkTa-ubuL9Do")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}