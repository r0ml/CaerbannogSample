
import SwiftUI
import Caerbannog

extension AppDelegate {
  public func runDominateDemo() {
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
    
    
    let str = """
import dominate
from dominate.tags import *

doc = dominate.document(title='Dominate your HTML')

with doc.head:
    link(rel='stylesheet', href='style.css')
    script(type='text/javascript', src='script.js')

with doc:
    with div(id='header').add(ol()):
        for i in ['home', 'about', 'contact']:
            li(a(i.title(), href='/%s.html' % i))
    with div():
        attr(cls='body')
        p('Lorem ipsum..')

"""
    
    let z = str.cString(using: .utf8)!
    
    let globs = PyModule_GetDict( Python.__main__.retained() )
//    let globs = try! Python.globals()
//    let locs = try! Python.locals()
    
    let zz = PyRun_StringFlags(z, Py_file_input, globs, globs, nil)
    
    let gd = Dictionary<String,PythonObject>(PythonObject(retaining: globs!))!

    let hh = gd["doc"]!
    let hi = try! String(hh.__str__())!
    
    let window = NSWindow(
      contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
      styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
      backing: .buffered, defer: false)
    window.center()
    window.setFrameAutosaveName("Dominate Demo")
    window.isReleasedWhenClosed = false
    window.contentView = NSHostingView(rootView: DominateView(html: hi))
    
    //    window.registerForDraggedTypes([NSPasteboard.PasteboardType.png, .tiff])
    //    window.contentView?.registerForDraggedTypes([kUTTypeImage as String, kUTTypeJPEG as String, kUTTypePNG as String])
    
    window.makeKeyAndOrderFront(nil)
    

    
  }
}

struct DominateView : View {
  @State var tgt : Bool = false
  @State var asciid : String?
  @State var visible : Bool = false
  
  var html : String
  
  var body : some View {
    Text(html).lineLimit(60)
  }
}

struct Dominate_Previews: PreviewProvider {
  static var previews: some View {
    DominateView(html: "<h1>this is a test</h1>")
  }
}




