import SwiftUI

// Clean Code: DRY - one form for adding (book is nil) and editing (book has a value)
struct BookFormSheet: View {
    @Environment(\.dismiss) private var dismiss
    let viewModel: BookViewModel
    var book: Concert?
    
    let zonas = ["General $800", "Preferente $1,500", "VIP $3,000"]
    @Binding var zona: String
    @Binding var cantidad: Int
    @Binding var estacionamiento: Bool
    @Binding var total: Int
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Boletos") {
                    Picker("Elige tu zona", selection: $zona) {
                        ForEach(zonas, id: \.self) { zona in
                            Text(zona)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    Toggle("Estacionamiento", isOn: $estacionamiento)
                    Stepper("Cantidad de boletos: \(cantidad)", value: $cantidad, in: 0...4)
                }
            }
            .navigationTitle(book == nil ? "New Book" : "Edit Book")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(!Concert.isValidTitle(zona))
                }
            }
            .alert("Couldn't Save", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .onAppear(perform: copyBookIntoForm)
            .presentationDetents([.medium])
        }
    }

    /// Copies the book into the form, so Cancel really cancels
    private func copyBookIntoForm() {
        guard let book else { return }
        zona = book.zona
        cantidad = book.cantidad
        estacionamiento = book.estacionamiento
        total = book.total
    }



    private func save() {
        do {
            let total = viewModel.totalPrice(zona: zona, cantidad: cantidad, estacionamiento: estacionamiento)
            if let book {
                try viewModel.update(book,
                     zona: Concert.clean(zona),
                     cantidad: cantidad,
                     estacionamiento: estacionamiento,
                     total: total)
            } else {
                try viewModel.add(zona: Concert.clean(zona),
                                  cantidad: cantidad,
                                  estacionamiento: estacionamiento,
                                  total: total)
            }
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
}
