struct CityResponse: Codable {
    let status: String
    let data: [City]
}

struct City: Codable {
    let cities: String  // İl adı
    let slug: String
}

struct DistrictResponse: Codable {
    let status: String
    let data: [District]
}

struct District: Codable {
    let cities: String  // İlçe/semt adı
    let slug: String
}
