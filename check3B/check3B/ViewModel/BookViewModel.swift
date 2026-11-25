import Foundation
import Observation
import SwiftData

// Clean Code: single responsibility - keeps the list and does create, update and delete
@MainActor
@Observable
class BookViewModel {
    
    // The context comes from the View (@Environment), which gets it from the App
    private var context: ModelContext?
    let zonas = ["General $800", "Preferente $1,500", "VIP $3,000"]
    
    func setContext(_ context: ModelContext) {
        self.context = context
    }
    
    func add(zona: String, cantidad: Int, estacionamiento: Bool, total: Int) throws {
        guard Concert.isValidTitle(zona) else {
            throw BookError.invalidTitle
        }
        let book = Concert(zona: Concert.clean(zona),
                           cantidad: cantidad,
                           estacionamiento: estacionamiento,
                           total: total,
        )
        context?.insert(book)
        try save()
    }
    
    func update(_ book: Concert, zona: String, cantidad: Int, estacionamiento: Bool, total: Int) throws {
        guard Concert.isValidTitle(zona) else {
            throw BookError.invalidTitle
        }
        book.zona = Concert.clean(zona)
        book.cantidad = cantidad
        book.estacionamiento = estacionamiento
        book.total = total
        try save()
    }
    
    func delete(_ concerts: [Concert]) throws {
        for concert in concerts {
            context?.delete(concert)
        }
        try save()
    }
    
    private func save() throws {
        guard let context else { throw BookError.saveFailed }
        do {
            try context.save()
        } catch {
            // Undo the unsaved changes so the list matches the database
            context.rollback()
            throw BookError.saveFailed
        }
    }
    
    func totalPrice(zona: String, cantidad: Int, estacionamiento: Bool) -> Int {
        var total = 0;
        var can = cantidad
        if can > 4 {
            can = 4
        }
        
        if zona == zonas[0] {
            total += 800 * can
        } else if zona == zonas[1] {
            total += 1500 * can
        } else {
            total += 3000 * can
        }
        
        if estacionamiento && total != 0{
            total += 250
        }
        return total
    }
}
