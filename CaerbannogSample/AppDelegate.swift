//
//  AppDelegate.swift
//  CaerBannogSample
//
//  Created by Robert Lefkowitz on 8/31/19.
//  Copyright © 2019 Semaseology. All rights reserved.
//

import Cocoa
import SwiftUI
import Caerbannog

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  var window: NSWindow!

  static var only : AppDelegate {
    get {
      return NSApp.delegate as! AppDelegate
    }
  }
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
    window = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
        styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
        backing: .buffered, defer: false)
    window.center()
    window.setFrameAutosaveName("Main Window")

    window.contentView = NSHostingView(rootView: ContentView())

    window.makeKeyAndOrderFront(nil)
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }
}

// ===========================================================================================
// Menu actions to run various demos
// ===========================================================================================
