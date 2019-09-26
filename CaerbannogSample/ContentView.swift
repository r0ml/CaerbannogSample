
import SwiftUI

struct ContentView: View {
  let ad = AppDelegate.only
   
    var body: some View {
          VStack() {
            Text("Check out the source code to see how it works!").fixedSize(horizontal: false, vertical: false ).frame(alignment: .leading).layoutPriority(10)
          Buttonier(label: "Run Google Images Downloads", action: ad.runGoogleImagesDownload)
          Buttonier(label: "Run Asciify demo", action: ad.runAsciify)
          Buttonier(label: "Run NumpyMatplotlib", action: ad.runNumpyMatplotlibDemo)
          Buttonier(label: "Run Dominate demo", action: ad.runDominateDemo )
          Buttonier(label: "Run Boto demo", action: ad.runBotoDemo )
          Buttonier(label: "Run Numpy demo", action: ad.runNumpyDemo)
            Buttonier(label: "Run Module demo", action: ad.runModuleDemo)
          }.frame(minWidth: 250, minHeight: 200).padding(.horizontal, 40).padding(.vertical, 20)
            .fixedSize(horizontal: false, vertical: false)
  }
}

// I needed this in order to make all the buttons the same width in the VStack
struct Buttonier : View {
  var label : String
  var action : () -> ()
  
  var body : some View {
    GeometryReader() { gg in Button(action: self.action) {
      Text(self.label).frame(minWidth: gg.size.width, alignment: .leading)
    } }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
