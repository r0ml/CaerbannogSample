
import SwiftUI
import Caerbannog

extension AppDelegate {
  public func runDominateDemo() {
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
    var hi : String
    if let zz = Python.run(str, returning: "doc"),
      let hh = try? String(zz.__str__()) {
      hi = hh
    } else {
      hi = "dominate demo failed"
    }

    let window = NSWindow(
      contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
      styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
      backing: .buffered, defer: false)
    window.center()
    window.setFrameAutosaveName("Dominate Demo")
    window.isReleasedWhenClosed = false
    window.contentView = NSHostingView(rootView: DominateView(html: hi))
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
