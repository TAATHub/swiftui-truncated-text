import SwiftUI

struct TrancatedText: View {
    struct Ellipsis {
        var text: String = ""
        var color: Color = .black
        var fontSize: CGFloat?
    }

    @State private var truncated: Bool = false
    @State private var truncatedText: String

    let lineLimit: Int
    let lineSpacing: CGFloat
    let font: UIFont
    let ellipsis: Ellipsis
    let proxy: GeometryProxy?

    private var text: String
    private var ellipsisPrefixText: String {
        return truncated ? "... " : ""
    }

    private var ellipsisText: String {
        return truncated ? ellipsis.text : ""
    }

    private var ellipsisFont: Font {
        if let fontSize = ellipsis.fontSize {
            return Font(font.withSize(fontSize))
        } else {
            return Font(font)
        }
    }

    init(
        _ text: String,
        lineLimit: Int,
        lineSpacing: CGFloat = 2,
        font: UIFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body),
        ellipsis: Ellipsis = Ellipsis(),
        proxy: GeometryProxy? = nil) {
        self.text = text
        self.lineLimit = lineLimit
        self.lineSpacing = lineSpacing
        self.font = font
        self.ellipsis = ellipsis
        self.proxy = proxy

        _truncatedText = State(wrappedValue: text)
    }

    var body: some View {
        Group {
            // 省略されたテキスト
            Text(truncatedText)
                + Text(ellipsisPrefixText)
                + Text(ellipsisText)
                .font(ellipsisFont)
                .foregroundColor(ellipsis.color)
        }
        .multilineTextAlignment(.leading)
        .lineLimit(lineLimit)
        .lineSpacing(lineSpacing)
        .background(
            // lineLimitで制限されたテキストをレンダリングして、そのサイズを計測しながら表示できるテキストを更新する
            Text(text)
                // 計測用のレイヤーなので非表示にする
                .hidden()
                .lineLimit(lineLimit)
                .background(GeometryReader { visibleTextGeometry in
                    Color.clear
                        .onAppear {
                            searchTruncatedText(width: proxy?.size.width ?? visibleTextGeometry.size.width,
                                                height: visibleTextGeometry.size.height)
                        }
                }))
        .font(Font(font))
    }
    
    private func searchTruncatedText(width: CGFloat, height: CGFloat) {
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]

        // 二分探索で省略テキストを更新する
        // 終了条件: mid == low && mid == high
        var low = 0
        var heigh = truncatedText.count
        var mid = heigh

        while (heigh - low) > 1 {
            // 固定幅に対するテキストの高さを取得するためにNSAttributedStringを用いる
            let attributedText = NSAttributedString(
                string: truncatedText + ellipsisPrefixText + ellipsisText,
                attributes: attributes)
            let boundRect = attributedText.boundingRect(
                with: size,
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                context: nil)

            if boundRect.size.height > height {
                truncated = true
                heigh = mid
                mid = (heigh + low) / 2
            } else {
                if mid == text.count {
                    break
                } else {
                    low = mid
                    mid = (low + heigh) / 2
                }
            }

            // truncatedTextの更新による再描画はSwiftUIが管理しており、この二分探索の処理による再描画は最終更新後に行われた
            truncatedText = String(text.prefix(mid))
        }
    }
}

struct TrancatedText_Previews: PreviewProvider {
    static var previews: some View {
        TrancatedText(
            "サンプルテキストサンプルテキストサンプルテキストサンプルテキストサンプルテキストサンプルテキストサンプルテキストサンプルテキストサンプルテキストサンプルテキスト",
            lineLimit: 3,
            ellipsis: .init(text: "More", color: .blue))
    }
}
