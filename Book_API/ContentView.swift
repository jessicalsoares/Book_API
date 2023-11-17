import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI
import WebKit
import SafariServices

struct ContentView: View {
    var body: some View {
        NavigationView {
            Home()
                .navigationBarTitle("Books")
        }
    }
}

struct Home : View {
    @ObservedObject var Books = getData()
    @State var show = false
    @State var selectedBook: Book?
    @State private var isLoadingMore = false
    @State private var showFavorites = false
    @State private var favoriteBookIDs = FavoriteBooksState.getFavorites()
    
    var columns: [GridItem] = [
        GridItem(.flexible(minimum: 150, maximum: 200), spacing: 10),
        GridItem(.flexible(minimum: 150, maximum: 200), spacing: 10)
    ]
    
    var body: some View {
        let filteredBooks: [Book]
        if showFavorites {
            filteredBooks = Books.data.filter { favoriteBookIDs.contains($0.id) }
        } else {
            filteredBooks = Books.data
        }
        
        return ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(Array(filteredBooks.enumerated()), id: \.element.id) { (index, book) in
                    VStack(alignment: .leading, spacing: 10) {
                        if !book.imurl.isEmpty {
                            WebImage(url: URL(string: book.imurl)!).resizable()
                                .frame(width: 120, height: 170)
                                .cornerRadius(10)
                                .padding(.leading, 10)
                                .padding(.trailing, 10)
                        } else {
                            Image("books").resizable()
                                .frame(width: 120, height: 170)
                                .cornerRadius(10)
                                .padding(.leading, 10)
                                .padding(.trailing, 10)
                        }
                        
                        Text(book.title)
                            .fontWeight(.bold)
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                        
                        Text(book.desc)
                            .font(.caption)
                            .lineLimit(4)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                        
                        Button(action: {
                            if let index = Books.data.firstIndex(where: { $0.id == book.id }) {
                                Books.data[index].isFavorite.toggle()
                                if Books.data[index].isFavorite {
                                    favoriteBookIDs.append(book.id)
                                } else {
                                    favoriteBookIDs.removeAll(where: { $0 == book.id })
                                }
                                FavoriteBooksState.saveFavoritesPublic(favoriteBookIDs)
                            }
                        }) {
                            Image(systemName: book.isFavorite ? "star.fill" : "star")
                                .foregroundColor(book.isFavorite ? .yellow : .gray)
                        }
                    }
                    .onTapGesture {
                        self.selectedBook = book
                        self.show.toggle()
                    }
                    .onAppear {
                        if index == Books.data.count - 1 {
                            if !isLoadingMore {
                                Books.loadBooks(startIndex: Books.data.count)
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 10)
        .sheet(isPresented: self.$show){
            if let selectedBook = self.selectedBook {
                BookDetailView(book: selectedBook)
            }
        }
        .navigationBarItems(trailing: Button(action: {
            showFavorites.toggle()
        }) {
            Image(systemName: showFavorites ? "star.fill" : "star")
                .foregroundColor(showFavorites ? .yellow : .gray)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

