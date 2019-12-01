import UIKit

enum UserDefaultKeys {
    static let isFirstLaunch = "isFirstLaunch"
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let isNotFirstLaunch = UserDefaults.standard.bool(forKey: UserDefaultKeys.isFirstLaunch)
        if !isNotFirstLaunch {
            let posts = Generator.getData()
            LocalDataManager.shared.savePosts(postModels: posts)
            UserDefaults.standard.set(true, forKey: UserDefaultKeys.isFirstLaunch)
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
}

