import SwiftUI

struct ContentView: View {
    
    @State var personVM = PersonViewModel()
    
    var body: some View {
        List(personVM.arrPeople) { item in
            Text(item.name)
            Text("\(item.species) - \(item.status)")
            AsyncImage(url: URL(string: item.image ?? "")) { img in
                img.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(height: 100)
        }
        .task {
            do {
                try await personVM.getPeople()
            } catch {
                print("error calling the people:", error)
            }
        }
    }
}

#Preview {
    ContentView()
}
