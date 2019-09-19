
import SwiftUI
import Caerbannog

extension AppDelegate {
  public func runBotoDemo() {

    
    let window = NSWindow(
      contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
      styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
      backing: .buffered, defer: false)
    window.center()
    window.setFrameAutosaveName("Boto Demo")
    window.isReleasedWhenClosed = false
    window.contentView = NSHostingView(rootView: BotoView())
    
    //    window.registerForDraggedTypes([NSPasteboard.PasteboardType.png, .tiff])
    //    window.contentView?.registerForDraggedTypes([kUTTypeImage as String, kUTTypeJPEG as String, kUTTypePNG as String])
    
    window.makeKeyAndOrderFront(nil)
    

    
  }
}

struct BotoView : View {
  @State var accessKey : String = ""
  @State var secretKey : String = ""
  @State var result : String = "no result yet"
  
  var body : some View {
    VStack() {
      TextField("Access Key", text: $accessKey)
      TextField("Secret Key", text: $secretKey)
      Button("Run Boto S3") { self.result = self.runBotoDemo().joined(separator: "\n") }
      TextField("", text: $result).lineLimit(60)
    }
  }
  
  
  func runBotoDemo() -> [String] {
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
import boto3

    ## Or via the Session
    #session = boto3.Session(
    #    aws_access_key_id=ACCESS_KEY,
    #    aws_secret_access_key=SECRET_KEY,
    #    aws_session_token=SESSION_TOKEN,
    #)

    # Retrieve the list of existing buckets
s3 = boto3.client('s3', aws_access_key_id=ACCESS_KEY, aws_secret_access_key=SECRET_KEY)
response = s3.list_buckets()

    # Output the bucket names
result = []
for bucket in response['Buckets']:
    result.append(bucket["Name"])

"""
        
        let z = str.cString(using: .utf8)!
        
        let globs = PyModule_GetDict( Python.__main__.retained() )
    //    let globs = try! Python.globals()
    //    let locs = try! Python.locals()
    PyDict_SetItem(globs, "ACCESS_KEY".pythonObject.retained(), self.accessKey.pythonObject.retained())
    PyDict_SetItem(globs, "SECRET_KEY".pythonObject.retained(), self.secretKey.pythonObject.retained())
    
    
        let zz = PyRun_StringFlags(z, Py_file_input, globs, globs, nil)
        
        let gd = Dictionary<String,PythonObject>(PythonObject(retaining: globs!))!

        let hh = gd["result"]!
        return  try! [String](hh)!
    
  }
}

struct Boto_Previews: PreviewProvider {
  static var previews: some View {
    BotoView()
  }
}




