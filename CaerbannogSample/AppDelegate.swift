
import SwiftUI
import Caerbannog

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  static var only : AppDelegate { get { return NSApp.delegate as! AppDelegate } }
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    let window = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
        styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
        backing: .buffered, defer: false)
    window.center()
    window.isReleasedWhenClosed = false
    window.setFrameAutosaveName("Caerbannog Sample Window")
    window.contentView = NSHostingView(rootView: ContentView())
    window.makeKeyAndOrderFront(nil)

    // Quit when this menu window is closed
    NotificationCenter.default.addObserver(forName: NSWindow.willCloseNotification, object: window, queue: nil) {_ in
      NSApp.terminate(self)
    }

  }

  func applicationWillTerminate(_ aNotification: Notification) {
  }
  
}
