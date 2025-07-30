import Foundation

struct EczaneResponse: Codable {
    let status: String
    let message: String
    let messageTR: String
    let systemTime: Int
    let endpoint: String
    let rowCount: Int
    let creditUsed: Int
    let data: [Pharmacy]
}

struct Pharmacy: Codable {
    let pharmacyID: Int
    let pharmacyName: String
    let address: String
    let city: String
    let district: String
    let town: String?                 // null olabilir
    let directions: String?          // null olabilir
    let phone: String?               // null olabilir
    let phone2: String?              // null olabilir
    let pharmacyDutyStart: String?   // null olabilir
    let pharmacyDutyEnd: String?     // null olabilir
    let latitude: Double
    let longitude: Double
}
