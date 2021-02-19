import UIKit
import Flutter
import Firebase
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

    BTAppSwitch.setReturnURLScheme("com.app.facesbyplaces.payments")
    return true
  }

  override func application(_ app: UIApplication, 
    open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
      if url.scheme?.localizedCaseInsensitiveCompare("com.app.facesbyplaces.payments") == .orderedSame {
          return BTAppSwitch.handleOpen(url, options: options)
      }
      return false
  }

  func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
      present(viewController, animated: true, completion: nil)
  }

  func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
      viewController.dismiss(animated: true, completion: nil)
  }
}
