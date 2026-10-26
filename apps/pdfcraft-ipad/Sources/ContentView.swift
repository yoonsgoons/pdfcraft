
import SwiftUI
import PDFKit
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var document: PDFDocument?
    @State private var showingFilePicker = false

    var body: some View {
        NavigationStack {
            Group {
                if let document {
                    PDFDocumentView(document: document)
                } else {
                    ContentUnavailableView {
                        Label("PDFCraft", systemImage: "doc.text")
                    } description: {
                        Text("Open a PDF to get started.")
                    } actions: {
                        Button("Open PDF") {
                            showingFilePicker = true
                        }
                    }
                }
            }
            .navigationTitle("PDFCraft")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingFilePicker = true
                    } label: {
                        Label("Open PDF", systemImage: "folder")
                    }
                }
            }
            .fileImporter(
                isPresented: $showingFilePicker,
                allowedContentTypes: [.pdf]
            ) { result in
                if case .success(let url) = result {
                    let access = url.startAccessingSecurityScopedResource()
                    defer {
                        if access {
                            url.stopAccessingSecurityScopedResource()
                        }
                    }
                    document = PDFDocument(url: url)
                }
            }
        }
    }
}

struct PDFDocumentView: UIViewRepresentable {
    let document: PDFDocument

    func makeUIView(context: Context) -> PDFView {
        let view = PDFView()
        view.autoScales = true
        view.displayMode = .singlePageContinuous
        view.displayDirection = .vertical
        view.document = document
        return view
    }

    func updateUIView(_ view: PDFView, context: Context) {
        if view.document !== document {
            view.document = document
        }
    }
}
