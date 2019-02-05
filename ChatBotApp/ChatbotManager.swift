//
//  ChatbotManager.swift
//  ChatBotApp
//
//  Created by Oneview Infosys on 05/02/19.
//  Copyright © 2019 Oneview Infosys. All rights reserved.
//

import UIKit
class ChatbotManager {
    
    //MARK: - Singleton
    
    static let sharedInstance = ChatbotManager()
    
    private init() {}
    private var chatbotWindow: UIWindow?

    func navigateToVideoCallViewController() {
        
        if let window = self.chatbotWindow, window.isKeyWindow {
            return
        }
        chatbotWindow = UIWindow.init(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let videoVC = storyboard.instantiateViewController(withIdentifier: "ChatBotVC") as! ChatBotVC
        self.chatbotWindow?.rootViewController = videoVC
        self.chatbotWindow?.makeKeyAndVisible()
    }

    func returnToWindowOfAppDelegate() {
        
        if let window = self.chatbotWindow, window.isKeyWindow {
            (UIApplication.shared.delegate as? AppDelegate)?.window?.makeKeyAndVisible()
            self.chatbotWindow = nil
        }
    }
}
