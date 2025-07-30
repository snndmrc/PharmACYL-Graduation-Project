import UIKit

class WelcomeView: UIViewController {

    @IBOutlet weak var aramaButtonUI: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        aramaButtonUI.setTitle("Bölgeni Seç", for: .normal)
        aramaButtonUI.layer.cornerRadius = 10
        aramaButtonUI.setTitleColor(.white, for: .normal)
        aramaButtonUI.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1)
        aramaButtonUI.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }

    @IBAction func aramaButtonTapped(_ sender: Any) {
        aramaButtonUI.isEnabled = false
        let dataService = TurkeyDataService()
        dataService.fetchCities { [weak self] cities in
            DispatchQueue.main.async {
                self?.aramaButtonUI.isEnabled = true
                if let cities = cities {
                    // CityResponse oluştur, UserInputView’a yolla
                    let cityResponse = CityResponse(status: "success", data: cities)
                    self?.presentUserInputView(with: cityResponse)
                } else {
                    print("Veri çekme işlemi başarısız.")
                }
            }
        }
    }

     
 
    private func presentUserInputView(with cityResponse: CityResponse) {
        guard let userInputVC = storyboard?.instantiateViewController(withIdentifier: "UserInputView") as? UserInputView else {
            print("UserInputView bulunamadı")
            return
        }
        userInputVC.modalPresentationStyle = .fullScreen
        userInputVC.cityResponse = cityResponse
        present(userInputVC, animated: true)
    }
}
