import SwiftUI

struct ContentView: View {
    let text = "吾輩は猫である。\n名前はまだ無い。\nどこで生れたかとんと見当がつかぬ。\n何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。\n吾輩はここで始めて人間というものを見た。"

    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 40) {
                Text(text)
                    .lineLimit(2)
                
                // 内部のGeometryProxyでサイズを計測する
                TrancatedText(text,
                              lineLimit: 2,
                              ellipsis: .init(text: "More", color: .blue))

                // GeometryProxyを渡して、親Viewのwidthを使ってサイズを計測する
                TrancatedText(text,
                              lineLimit: 2,
                              ellipsis: .init(text: "More", color: .blue),
                              proxy: proxy)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
