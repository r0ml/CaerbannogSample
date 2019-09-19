
import SwiftUI

struct ContentView: View {
    var body: some View {
      VStack() {
        Button("Run Google Images Downloads") { AppDelegate.only.runGoogleImagesDownload() }
        Button("Run Asciify demo") { AppDelegate.only.runAsciify() }
        Button("Run NumpyMatplotlib demo") { AppDelegate.only.runNumpyMatplotlibDemo() }
        Button("Run Dominate demo") { AppDelegate.only.runDominateDemo() }
        Button("Run Boto demo") { AppDelegate.only.runBotoDemo() }
        Button("Run Numpy demo") { AppDelegate.only.runNumpyDemo() }
      }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
