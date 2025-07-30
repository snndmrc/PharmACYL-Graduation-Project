import Foundation

class EczaneDataService {
    
    private let apiKey = "Bearer jCojJQOxqQZpP22fu1uyzN9IiK2qrETCH3MUYHsTlrA8Kw3LwfgNQ5DFBU6Z"
    
    func fetchPharmacies(forCity city: String, district: String, completion: @escaping (EczaneResponse?) -> Void) {
        let baseURL = "https://www.nosyapi.com/apiv2/service/pharmacies-on-duty?district=&city="
        var components = URLComponents(string: baseURL)!
        
        components.queryItems = [
            URLQueryItem(name: "city", value: city),
            URLQueryItem(name: "district", value: district)
        ]
        
        guard let url = components.url else {
            print("❌ Geçersiz URL")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        
        print("🌐 API URL: \(url.absoluteString)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("❌ Network hatası: \(error.localizedDescription)")
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Geçersiz HTTP yanıtı")
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            print("⬅️ HTTP Durum Kodu: \(httpResponse.statusCode)")
            
            guard httpResponse.statusCode == 200 else {
                print("❌ HTTP Hatası: \(httpResponse.statusCode)")
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            guard let data = data else {
                print("❌ Veri alınamadı")
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responseModel = try decoder.decode(EczaneResponse.self, from: data)
                print("✅ Başarılı: \(responseModel.data.count) eczane alındı")
                DispatchQueue.main.async { completion(responseModel) }
            } catch {
                print("❌ JSON Decode hatası: \(error.localizedDescription)")
                if let raw = String(data: data, encoding: .utf8) {
                    print("🔍 Gelen JSON:\n\(raw)")
                }
                DispatchQueue.main.async { completion(nil) }
            }
            
        }.resume()
    }
}
