//
//  AppDelegate.swift
//  noteYandexPractice
//
//  Created by Admin on 22/06/2019.
//  Copyright © 2019 musamuss. All rights reserved.
//

import UIKit
import CocoaLumberjack

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var fileNotebook = FileNotebook(notes: [])
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let ttyLogger = DDTTYLogger()
        DDLog.add(ttyLogger)
        
        DDLogInfo("Application start")
        
        // загружем заметки
        fileNotebook.loadFromFile()
        
        if (fileNotebook.notes.isEmpty){
            fileNotebook = FileNotebook(notes: Note.demoNotes)
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        DDLogDebug("Application become inactive")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        DDLogDebug("Application go to background")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        DDLogDebug("Application return foreground")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        DDLogDebug("Application become active")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        DDLogInfo("Application start terminate")
        
        // сохраняем заметки
        fileNotebook.saveToFile()
    }
    
    
}
