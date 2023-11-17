import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI
import WebKit
import SafariServices

struct BookDetailView: View {
    let book: Book
    
    @State private var isShowingSafariView = false
    
    var body: some View {
        VStack {
            Spacer()
            
            if !book.imurl.isEmpty {
                WebImage(url: URL(string: book.imurl)!).resizable()
                    .frame(width: 180, height: 210)
                    .cornerRadius(10)
            } else {
                Image("books").resizable()
                    .frame(width: 200, height: 280)
                    .cornerRadius(10)
            }
            
            Spacer()
            
            Text(book.title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.leading, 10)
                .padding(.trailing, 10)
            
            Spacer()
            
            Text("Autor: \(book.authors)")
                .font(.headline)
            
            Spacer()
            
            Text(book.desc)
                .font(.body)
                .multilineTextAlignment(.leading)
                .lineLimit(10)
                .padding(.leading, 10)
                .padding(.trailing, 10)
            
            Spacer()
            
            if !book.url.isEmpty {
                HStack {
                    Button(action: {
                        if let url = URL(string: book.url) {
                            isShowingSafariView = true
                        }
                    }) {
                        Text("Buy")
                            .padding()
                            .frame(height: 50)
                            .background(Color.blue) // Cor de fundo para o botão "Comprar"
                            .foregroundColor(.white) // Cor do texto
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        book.isFavorite.toggle()
                    }) {
                        Image(systemName: book.isFavorite ? "star.fill" : "star")
                            .foregroundColor(book.isFavorite ? .yellow : .white)
                            .frame(height: 30)
                    }
                    .padding(10) // Espaçamento entre os botões
                    .background(Color.blue) // Cor de fundo para o botão de favoritos
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                }
                .sheet(isPresented: $isShowingSafariView) {
                    SafariView(url: URL(string: book.url)!)
                }
            }
            
            
            Spacer()
        }
        .padding()
        .navigationBarTitle("Book Details")
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let safariViewController = SFSafariViewController(url: url)
        return safariViewController
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // Nada a fazer aqui
    }
}




