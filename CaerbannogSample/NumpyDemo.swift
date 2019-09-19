
import SwiftUI
import Caerbannog
import AVKit

public protocol NumpyScalar {
  static var scalarType: PythonObject { get }
}


extension Int16 : NumpyScalar {
  public static let scalarType = np.int16
}

private let np = Python.numpy

extension Array where Element : NumpyScalar {
  public init?(numpyArray: PythonObject) {
       // FIXME: put me back
       // Check if input is a `numpy.ndarray` instance.
       let bb = try? Python.isinstance(numpyArray, np.ndarray)
       guard let bbb = bb, let b = Bool(bbb) else {
         return nil
       }
       if !b { return nil }
    
       // Check if the dtype of the `ndarray` is compatible with the `Element` type.
    // This was "contains" because scalarType was an array of scalarTypes
       guard Element.scalarType == numpyArray.dtype else {
         return nil
       }

       // Only 1-D `ndarray` instances can be converted to `Array`.
       guard let pyShape = numpyArray.__array_interface__["shape"] else { return nil }
       guard let shape = Array<Int>(pyShape) else { return nil }
       guard shape.count == 1 else { return nil }

       // Make sure that the array is contiguous in memory. This does a copy if
       // the array is not already contiguous in memory.
       let contiguousNumpyArray = try! np.ascontiguousarray(numpyArray)

       guard let ptrVal =
        UInt(contiguousNumpyArray.__array_interface__["data"]![0]!) else {
         return nil
       }
       guard let ptr = UnsafePointer<Element>(bitPattern: ptrVal) else {
         fatalError("numpy.ndarray data pointer was nil")
       }
       // This code avoids constructing and initialize from `UnsafeBufferPointer`
       // because that uses the `init<S : Sequence>(_ elements: S)` initializer,
       // which performs unnecessary copying.
       let dummyPointer = UnsafeMutablePointer<Element>.allocate(capacity: 1)
       let scalarCount = shape.reduce(1, *)
       self.init(repeating: dummyPointer.move(), count: scalarCount)
       dummyPointer.deallocate()
       withUnsafeMutableBufferPointer { buffPtr in
         buffPtr.baseAddress!.assign(from: ptr, count: scalarCount)
       }
  }
}

extension AppDelegate {
  public func runNumpyDemo() {
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
fs = 8000 # Hz
T = 1. # second, arbitrary length of tone

# 1 kHz sine wave, 1 second long, sampled at 8 kHz
t = np.arange(0, T, 1/fs)
x = 0.5 * np.sin(2*np.pi*1000*t)   # 0.5 is arbitrary to avoid clipping sound card DAC
x  = (x*32768).astype(np.int16)  # scale to int16 for sound card
"""
    
    let z = str.cString(using: .utf8)!
    
    let globs = PyModule_GetDict( Python.__main__.retained() )
//    let globs = try! Python.globals()
//    let locs = try! Python.locals()
    
    let zz = PyRun_StringFlags(z, Py_file_input, globs, globs, nil)
    
    let gd = Dictionary<String,PythonObject>(PythonObject(retaining: globs!))!

    let hh = gd["x"]!
    
    var  hmx = [Int16](numpyArray: hh)!
    let hdd = withUnsafeBytes(of: hmx) {
      Data(bytes: $0.baseAddress!, count: $0.count) //  2 * hmx.count)
    }
    

    // pcmFormatInt16 gives me an error?
    let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 8000, channels: 1, interleaved: false)

    let buf = AVAudioPCMBuffer.init(pcmFormat: format!, frameCapacity: 8000)!
    buf.frameLength = 8000
    
    let ab = buf.floatChannelData!.pointee
    let cc = hmx.count
    
    (0..<hmx.count).forEach { ab[$0] = Float(hmx[$0]) / Float(32768) }
/*
    withUnsafeMutablePointer(to: &hmx) { up in
      up.withMemoryRebound(to: Int16.self, capacity: cc) {
      ab.initialize(from: $0, count: cc )
      }
    }
*/
    let audioEngine = AVAudioEngine()
    let playerNode = AVAudioPlayerNode()

    audioEngine.attach(playerNode)
    audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: format)

    audioEngine.prepare()
    
    
    do {
      try audioEngine.start()
    } catch {
      print("audio engine didn't start \(error.localizedDescription)")
    }
    
    playerNode.play()
    playerNode.scheduleBuffer(buf)

    /*
    let audioPlayer = try!
      AVAudioPlayer(data: hdd, fileTypeHint: AVFileType.wav.rawValue)
                     audioPlayer.prepareToPlay()
                     audioPlayer.volume = 0.5
                     audioPlayer.play()
                 }
    
 */
    
  /*
    let hi = try! String(hh.__str__())!
    
    let window = NSWindow(
      contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
      styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
      backing: .buffered, defer: false)
    window.center()
    window.setFrameAutosaveName("Numpy Demo")
    window.isReleasedWhenClosed = false
    window.contentView = NSHostingView(rootView: NumpyView(html: hi))
    
    //    window.registerForDraggedTypes([NSPasteboard.PasteboardType.png, .tiff])
    //    window.contentView?.registerForDraggedTypes([kUTTypeImage as String, kUTTypeJPEG as String, kUTTypePNG as String])
    
    window.makeKeyAndOrderFront(nil)
    */

    Thread.sleep(forTimeInterval: 2)
  }
}

struct NumpyView : View {
  @State var tgt : Bool = false
  @State var asciid : String?
  @State var visible : Bool = false
  
  var html : String
  
  var body : some View {
    Text(html).lineLimit(60)
  }
}

struct Numpy_Previews: PreviewProvider {
  static var previews: some View {
    NumpyView(html: "<h1>this is a test</h1>")
  }
}




