//
//  NumpyDemo.swift
//  CaerBannogSample
//
//  Created by Robert Lefkowitz on 9/17/19.
//  Copyright © 2019 Semaseology. All rights reserved.
//

import SwiftUI
import Caerbannog

extension AppDelegate {
  public func runNumpyMatplotlibDemo() {
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
import numpy as np
import matplotlib.pyplot as plt
import io
from PIL import Image

# Compute the x and y coordinates for points on sine and cosine curves
x = np.arange(0, 3 * np.pi, 0.1)
y_sin = np.sin(x)
y_cos = np.cos(x)

# Plot the points using matplotlib
plt.plot(x, y_sin)
plt.plot(x, y_cos)
plt.xlabel('x axis label')
plt.ylabel('y axis label')
plt.title('Sine and Cosine')
plt.legend(['Sine', 'Cosine'])

buf = io.BytesIO()
plt.savefig(buf, format='png')
buf.seek(0)
result = buf.getvalue()

# im = Image.open(buf)
# buf.close()

# buf = io.BytesIO()
# im.save(buf, 'PNG')
# result = buf.getvalue()
"""
    
    let z = str.cString(using: .utf8)!
    
    let globs = PyModule_GetDict( Python.__main__.retained() )
//    let globs = try! Python.globals()
//    let locs = try! Python.locals()
    
    let zz = PyRun_StringFlags(z, Py_file_input, globs, globs, nil)
    
    let gd = Dictionary<String,PythonObject>(PythonObject(retaining: globs!))!

    let hh = gd["result"]!
    let hi = Data(hh)!
    let imm = NSImage(data: hi)!

    
    let window = NSWindow(
      contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
      styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
      backing: .buffered, defer: false)
    window.center()
    window.setFrameAutosaveName("Numpy Matplotlib Demo")
    window.isReleasedWhenClosed = false
    window.contentView = NSHostingView(rootView: NumpyMatplotlibView(plot: imm))
    
    //    window.registerForDraggedTypes([NSPasteboard.PasteboardType.png, .tiff])
    //    window.contentView?.registerForDraggedTypes([kUTTypeImage as String, kUTTypeJPEG as String, kUTTypePNG as String])
    
    window.makeKeyAndOrderFront(nil)
    

    
  }
}

struct NumpyMatplotlibView : View {
  @State var tgt : Bool = false
  @State var asciid : String?
  @State var visible : Bool = false
  
  var plot : NSImage
  
  var body : some View {
          Image(nsImage: plot)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

struct NumpyMatplotlib_Previews: PreviewProvider {
  static var previews: some View {
    NumpyMatplotlibView(plot: NSImage() )
  }
}

