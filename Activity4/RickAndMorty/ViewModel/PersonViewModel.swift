import Foundation
import Observation

@MainActor @Observable
class PersonViewModel {
    
    var arrPeople = [Person]()
    
    func getPeople() async throws {
        
        guard let url = URL(string: "https://rickandmortyapi.com/api/character") else {
            print("invalid url")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            print("error")
            return
        }
        
        arrPeople = try JSONDecoder().decode(PersonResponse.self, from: data).results
    }
}
