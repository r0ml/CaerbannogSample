//
//  GoogleImagesDownloadDemo.swift
//  CaerBannogSample
//
//  Created by Robert Lefkowitz on 9/17/19.
//  Copyright © 2019 Semaseology. All rights reserved.
//

import AppKit
import Caerbannog

extension AppDelegate {
  
  public func runGoogleImagesDownload() {
   
    let sys = Python.sys
    let bb = Bundle.main.resourceURL!
    let bb1 = bb.appendingPathComponent("venv").appendingPathComponent("lib").appendingPathComponent("python3.7").appendingPathComponent("site-packages")
    try! sys.path.insert(0, bb1.path)
 

    print(Python.sys.path)
    
    let bbb = PyImport_ImportModule("certifi")!
    let cc = PythonObject(retaining: bbb)
    let jj = try! cc.where()
    print(jj)
    
    
    let os = Python.os
    os.environ["SSL_CERT_FILE"] = jj
    os.environ["REQUESTS_CA_BUNDLE"] = jj
    
//    var environment = ProcessInfo.processInfo.environment
    setenv("SSL_CERT_FILE", String.init(jj), 1)
    
  setenv("REQUESTS_CA_BUNDLE", String.init(jj), 1)

    print(os.environ["SSL_CERT_FILE"])
    
    try! print(Python.ssl.get_default_verify_paths())
    
    // FIXME:  I could implement a function that uses a context with the locally supplied
    // certs from certifi
    try! Python.setattr(Python.ssl, "_create_default_https_context", Python.ssl._create_unverified_context)
    
    let z = try! Python.ssl._create_unverified_context()
    print(z)
//    try! print(z.get_default_verify_paths())
    print(z.verify_mode)
    print(Python.ssl.CERT_NONE)
    
    do {
      let context = try Python.ssl.SSLContext(Python.ssl.PROTOCOL_TLS)
      context.verify_mode = try Python.ssl.CERT_REQUIRED
      try context.load_verify_locations(jj)
    } catch let error {
      print(error)
    }
    
    let aa = PyImport_ImportModule("google_images_download.google_images_download")!
//    let a = Python.google_images_download
    let a = PythonObject(retaining: aa)
    let b = try! a.googleimagesdownload()
    let c = [ "keywords":"kaleidoscopes".pythonObject, "limit":20.pythonObject, "print_urls": true.pythonObject,
              "output_directory": "/tmp".pythonObject ] // , "print_paths" : true.pythonObject ]
    let d = try! b.download(c)
    print(d)
    
/*
         // Do any additional setup after loading the view.
         let b = Bundle.main
     //    let p = b.path(forResource: "RayTrace", ofType: "py", inDirectory: "RayTrace")!
     //    let p = Bundle().path(forResource: "Functions.py", ofType: ".py", inDirectory: "Resources")
         let dd = b.resourceURL!.appendingPathComponent("RayTrace").path
         try! Python.sys.path.insert(0, dd)

         let mma = Python.RayTrace
         FileManager.default.changeCurrentDirectoryPath(b.resourcePath!)
         
         try! mma.main()
*/
    
   }

}

