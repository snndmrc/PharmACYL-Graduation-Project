class ListViewModel {
    private let service = EczaneDataService()
    private(set) var pharmacies: [Pharmacy] = []
    var errorMessage: String?

    func fetchPharmacies(forCity citySlug: String, districtSlug: String, completion: @escaping () -> Void) {
        service.fetchPharmacies(forCity: citySlug, district: districtSlug) { [weak self] response in
            guard let self = self else { return }
            
            if let response = response {
                self.pharmacies = response.data
                if self.pharmacies.isEmpty {
                    self.errorMessage = "Bu ilçede nöbetçi eczane bulunamadı."
                    print("ViewModel: Veri boş.")
                } else {
                    self.errorMessage = nil
                    print("ViewModel: \(self.pharmacies.count) eczane kaydı geldi.")
                }
            } else {
                self.pharmacies = []
                self.errorMessage = "Veri alınamadı. Lütfen tekrar deneyin."
                print("ViewModel: Hata var.")
            }

            completion()
        }
    }

    func numberOfItemsInSection() -> Int {
        pharmacies.count
    }

    func eczaneAtIndex(_ index: Int) -> Pharmacy? {
        guard index >= 0 && index < pharmacies.count else { return nil }
        return pharmacies[index]
    }
}
