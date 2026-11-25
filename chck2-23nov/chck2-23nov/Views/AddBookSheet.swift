//
//  AddBookSheet.swift
//  chck2-23nov
//
//  Created by Alumno on 23/11/26.
//

import SwiftUI

struct AddBookSheet: View {
    @Environment(\.dismiss) private var dismiss
    let bookVM : BookViewModel
    
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var synopsis: String = ""
    @State private var category: String = ""
    @State private var copies: Int = 0
    @State private var imageName: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                TextField("Author", text: $author)
                Stepper("Copies:\(copies)", value: $copies, in: 0...100)
                TextField("Description", text: $synopsis)
            }
            .navigationTitle("New Book")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Save") {
                        bookVM.addBook(title: title, author: author, synopsis: synopsis, category: category, copies: copies, imageName: imageName)
                        dismiss()
                    }
                }
            }
        }
    }
}
