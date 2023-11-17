import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI
import WebKit
import SafariServices

class Book : Identifiable, ObservableObject {
    var id : String
    var title : String
    var authors : String
    var desc : String
    var imurl : String
    var url : String
    @Published var isFavorite: Bool = false
    
    init(id: String, title: String, authors: String, desc: String, imurl: String, url: String, isFavorite: Bool) {
        self.id = id
        self.title = title
        self.authors = authors
        self.desc = desc
        self.imurl = imurl
        self.url = url
        self.isFavorite = isFavorite
        
    }
}
