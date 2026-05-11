import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let appIconChannelName = "two_mins/app_icon"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: appIconChannelName,
        binaryMessenger: controller.binaryMessenger
      )

      channel.setMethodCallHandler { call, result in
        switch call.method {
        case "setIcon":
          guard UIApplication.shared.supportsAlternateIcons else {
            result(FlutterError(
              code: "unsupported",
              message: "Alternate app icons are not supported on this device.",
              details: nil
            ))
            return
          }

          let icon = call.arguments as? String
          let iconName = icon == "alt" ? "AppIconAlt" : nil
          UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error = error {
              result(FlutterError(
                code: "set_icon_failed",
                message: error.localizedDescription,
                details: nil
              ))
              return
            }
            result(nil)
          }

        case "getIcon":
          result(UIApplication.shared.alternateIconName == "AppIconAlt" ? "alt" : "main")

        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
