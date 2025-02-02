//
//  SceneDelegate.swift
//  AKCOO
//
//  Created by 박혜운 on 11/4/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  let navigationController = UINavigationController()
  var appCoordinator: AppCoordinatorImp?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    self.window = UIWindow(windowScene: windowScene)
    self.window?.rootViewController = navigationController
    self.window?.makeKeyAndVisible()
    self.appCoordinator = AppCoordinatorImp(navigationController)
    self.appCoordinator?.start()
  }

  func sceneDidDisconnect(_ scene: UIScene) {
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
  }

  func sceneWillResignActive(_ scene: UIScene) {
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
  }
}
