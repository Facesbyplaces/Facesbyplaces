import UIKit
import Flutter
import Firebase
import BraintreeDropIn
import Braintree

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
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      if url.scheme?.localizedCaseInsensitiveCompare("com.app.facesbyplaces.braintree") == .orderedSame {
          return BTAppSwitch.handleOpen(url, options: options)
      }
      return false
  }
}