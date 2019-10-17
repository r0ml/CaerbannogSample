
import SwiftUI
import Caerbannog

extension AppDelegate {
  
  public func runGoogleImagesDownload() {
    let window = NSWindow(
      contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
      styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
      backing: .buffered, defer: false)
    window.center()
    window.setFrameAutosaveName("Google Images Download Window")
    window.isReleasedWhenClosed = false
    window.contentView = NSHostingView(rootView: GoogleImagesView())
    window.makeKeyAndOrderFront(nil)
  }
}

struct GoogleImagesView : View {
  @State var imgs : [NSImage] = []
  @State var keyword : String = ""

  var body : some View {
    VStack {
      Text("Try 'orange'")
      TextField("keyword", text: $keyword, onCommit: {
        let aa = Python.google_images_download.google_images_download
        let b = try! aa.googleimagesdownload()
        let c = [ "keywords":self.keyword.pythonObject, "limit":3.pythonObject, "print_urls": true.pythonObject,
                  "output_directory": FileManager.default.temporaryDirectory.path.pythonObject ] // , "print_paths" : true.pythonObject ]
        let d = try! b.download(c)
        let jj = d[0]!
        let kk = jj[self.keyword]!
        let ii = kk.map { String($0)! }
        self.imgs = ii.map { NSImage(contentsOfFile: $0)! }
      })
    List {
      ForEach(imgs, id: \.hash ) { i in
        Image(nsImage: i).resizable().aspectRatio(contentMode: .fit)
      }
    }
  }
  }
}
