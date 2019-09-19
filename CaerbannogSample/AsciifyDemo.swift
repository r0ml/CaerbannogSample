
import SwiftUI
import Caerbannog

extension AppDelegate {
  public func runAsciify() {
    let sys = Python.sys
    let bb = Bundle.main.resourceURL!
    let bb1 = bb.appendingPathComponent("venv").appendingPathComponent("lib").appendingPathComponent("python3.7").appendingPathComponent("site-packages")
    try! sys.path.insert(0, bb1.path)
    
    // need to do  PyImport_ImportModuleEx
    /*    let d1 = PyDict_New()!
     let d2 = PyDict_New()!
     let d3 = Dictionary<String,PythonObject>(PythonObject(retaining: d1))!
     let d5 = Dictionary<String,PythonObject>(PythonObject(retaining: d2))!
     
     let d6 = PyList_New(1)
     let d7 : PythonObject = "*".pythonObject
     PyList_SetItem(d6, 0, d7.retained() )
     let mm = PyImport_ImportModuleLevel("asciify", d1, d2, d6, 0)
     
     let d4 = d3["runner"]!
     */
    
    let window = NSWindow(
      contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
      styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
      backing: .buffered, defer: false)
    window.center()
    window.setFrameAutosaveName("Asciify Window")
    window.isReleasedWhenClosed = false
    window.contentView = NSHostingView(rootView: AsciifyView())
    
    //    window.registerForDraggedTypes([NSPasteboard.PasteboardType.png, .tiff])
    //    window.contentView?.registerForDraggedTypes([kUTTypeImage as String, kUTTypeJPEG as String, kUTTypePNG as String])
    
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
      HStack {
        if visible {
          Image(nsImage: img!)
            .resizable()
            .aspectRatio(contentMode: .fit)
          Text(asciid!).font(Font.custom("Courier", size: 15))
        }
      }.frame(width: nil, height: 400, alignment: .center)
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
        let j = try! Python.PIL.Image.open(f.path)
        let aa = try! Python.asciify.do(j)
        self.asciid = String(aa)
        self.visible = true
      }
      
    }
    return true
  }
  
}

