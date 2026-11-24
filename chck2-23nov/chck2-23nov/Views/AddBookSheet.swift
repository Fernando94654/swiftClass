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
        Text("Hello, World!")
    }
}
