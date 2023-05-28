import SwiftUI

struct ContentView: View {
    let text = "吾輩は猫である。名前はまだ無い。どこで生れたかとんと見当がつかぬ。何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。吾輩はここで始めて人間というものを見た。"

    var body: some View {
        VStack(spacing: 40) {
            Text(text)
                .lineLimit(3)

            TrancatedText(text,
                          lineLimit: 3,
                          ellipsis: .init(text: "More", color: .blue))
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
