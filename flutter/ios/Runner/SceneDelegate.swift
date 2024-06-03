//
//  SceneDelegate.swift
//  Runner
//
//  Created by Aaditya Kanjolia on 04/06/24.
//

import Foundation

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    window?.rootViewController = FlutterViewController()
    window?.makeKeyAndVisible()
  }

  // Implement other UISceneDelegate methods as needed
}
