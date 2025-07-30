class UserInputViewModel {
    private let dataService = TurkeyDataService()
    private var cities: [City] = []
    private var districts: [District] = []
    private var selectedCityIndex: Int?

    func fetchCities(completion: @escaping () -> Void) {
        dataService.fetchCities { [weak self] cities in
            self?.cities = cities ?? []
            completion()
        }
    }

    func fetchDistricts(completion: @escaping () -> Void) {
        guard let index = selectedCityIndex else {
            districts = []
            completion()
            return
        }
        let slug = cities[index].slug
        dataService.fetchDistricts(citySlug: slug) { [weak self] districts in
            self?.districts = districts ?? []
            completion()
        }
    }

    func provinces() -> [String] {
        return cities.map { $0.cities }
    }

    func districtsForSelectedCity() -> [String] {
        return districts.map { $0.cities}
    }

    func selectCity(at index: Int) {
        selectedCityIndex = index
    }

    func selectedCitySlug() -> String? {
        guard let index = selectedCityIndex else { return nil }
        return cities[index].slug
    }

    func districtSlug(at index: Int) -> String? {
        guard index < districts.count else { return nil }
        return districts[index].slug
    }
}
