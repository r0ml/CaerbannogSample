
import SwiftUI
import Caerbannog

extension AppDelegate {
  public func runAsciify() {

    let window = NSWindow(
      contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
      styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
      backing: .buffered, defer: false)
    window.center()
    window.setFrameAutosaveName("Asciify Window")
    window.isReleasedWhenClosed = false
    window.contentView = NSHostingView(rootView: AsciifyView())
    window.makeKeyAndOrderFront(nil)
  }
}

struct AsciifyView : View {
  @State var tgt : Bool = false
  @State var img : NSImage?
  @State var asciid : String?
  @State var visible : Bool = false
  
  var body : some View {
    VStack {
      Text("Drop an Image on me").frame(maxWidth: .infinity, maxHeight: .infinity)
        .onDrop(of: [NSPasteboard.PasteboardType.fileURL.rawValue], delegate: self  )
        .background(Color.gray)
      HStack {
        if visible {
          Image(nsImage: img!)
            .resizable()
            .aspectRatio(contentMode: .fit)
          ScrollView(.vertical, showsIndicators: true) {
            Text(asciid ?? "asciify failed").font(Font.custom("Courier", size: 15)).fixedSize(horizontal: false, vertical: true ).frame(alignment: .leading)

            }.layoutPriority(10).fixedSize(horizontal: false, vertical: true )
        }
      }.frame(minHeight: 400, alignment: .center).layoutPriority(10)// .fixedSize(horizontal: false, vertical: true )
    }
  }
}

struct Asciify_Previews: PreviewProvider {
  static var previews: some View {
    AsciifyView()
  }
}


extension AsciifyView : DropDelegate {
  
  func performDrop(info: DropInfo) -> Bool {
    let provider = info.itemProviders(for: [NSPasteboard.PasteboardType.fileURL.rawValue])
    provider[0].loadDataRepresentation(forTypeIdentifier: NSPasteboard.PasteboardType.fileURL.rawValue) {
      (data, error) in
      if let d = data,
        let ff = String(data: d, encoding: .utf8),
        let f = URL(string: ff),
        let i = NSImage(contentsOf: f) {
        self.img = i
      
          // animated GIF causes error to be thrown here
        if let j = try? Python.PIL.Image.open(f.path),
          let k = try? j.resize([150,75].pythonObject, Python.PIL.Image.ANTIALIAS),
          let aa = try? Python.asciify.do(k) {
          self.asciid = String(aa)
          self.visible = true
        } else {
          if PyErr_Occurred() != nil {
            PyErr_Print()
            PyErr_Clear()
          }
        }
      }
      
    }
    return true
  }
}

