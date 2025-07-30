import Foundation
class TurkeyDataService {
    private let apiKey = Constants.apiKey

    func fetchCities(completion: @escaping ([City]?) -> Void) {
        guard let url = URL(string: Constants.citiesURL) else {
            completion(nil)
            return
        }
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            do {
                let response = try JSONDecoder().decode(CityResponse.self, from: data)
                completion(response.data)
            } catch {
                print("JSON decode error:", error)
                completion(nil)
            }
        }.resume()
    }

    func fetchDistricts(citySlug: String, completion: @escaping ([District]?) -> Void) {
        let urlString = "\(Constants.citiesURL)?city=\(citySlug)"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            do {
                let response = try JSONDecoder().decode(DistrictResponse.self, from: data)
                completion(response.data)
            } catch {
                print("JSON decode error:", error)
                completion(nil)
            }
        }.resume()
    }
}
