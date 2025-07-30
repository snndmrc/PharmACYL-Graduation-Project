import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Kullanıcı onboarding’i görmüş mü?
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        let initialVC: UIViewController

        if hasSeenOnboarding {
            initialVC = storyboard.instantiateViewController(withIdentifier: "WelcomeView")
        } else {
            initialVC = OnboardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        }

        window?.rootViewController = initialVC
        window?.makeKeyAndVisible()

        return true
    }
}
