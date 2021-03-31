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
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    BTAppContextSwitcher.setReturnURLScheme("com.app.facesbyplaces.braintree")
    return true
  }
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      if url.scheme?.localizedCaseInsensitiveCompare("com.app.facesbyplaces.braintree") == .orderedSame {
          return BTAppContextSwitcher.handleOpenURL(url)
      }
      return false
  }
}