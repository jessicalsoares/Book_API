import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI
import WebKit
import SafariServices

class getData: ObservableObject {
    @Published var data = [Book]()
    @Published var isLoadingMore = false
    
    init() {
        loadBooks(startIndex: 0)
    }
    
    func loadBooks(startIndex: Int) {
        isLoadingMore = startIndex > 0
        
        let url = "https://www.googleapis.com/books/v1/volumes?q=ios&maxResults=20&startIndex=\(startIndex)"
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!) { (data, _, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            let json = try! JSON(data: data!)
            let items = json["items"].array!
            
            for item in items {
                let id = item["id"].stringValue
                let title = item["volumeInfo"]["title"].stringValue
                
                let authorsJSON = item["volumeInfo"]["authors"]
                let authorsArray = authorsJSON.arrayValue
                var author = ""
                
                for authorJSON in authorsArray {
                    author += authorJSON.stringValue
                }
                
                let description = item["volumeInfo"]["description"].stringValue
                let imurl = item["volumeInfo"]["imageLinks"]["thumbnail"].stringValue
                let url1 = item["volumeInfo"]["previewLink"].stringValue
                
                DispatchQueue.main.async {
                    self.data.append(Book(id: id, title: title, authors: author, desc: description, imurl: imurl, url: url1, isFavorite: false))
                    self.isLoadingMore = false
                }
            }
        }.resume()
    }
}

struct WebView : UIViewRepresentable{
    var url: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: self.url) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}
