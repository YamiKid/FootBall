import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Создание окна
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        // Создание основного контроллера (например, LoadingViewController)
        let mainViewController = LoadViewController()
        
        // Создание UINavigationController с основным контроллером
        let navigationController = UINavigationController(rootViewController: mainViewController)
        
        // Установка UINavigationController в качестве корневого контроллера окна
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}
