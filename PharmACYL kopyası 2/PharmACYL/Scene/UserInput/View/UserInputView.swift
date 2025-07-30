import UIKit

class UserInputView: UIViewController, UITextFieldDelegate {
    var viewModel = UserInputViewModel()
    var cityResponse: CityResponse?

    let provincePickerView = UIPickerView()
    let districtPickerView = UIPickerView()

    let provinceTextField = UITextField()
    let districtTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupPickers()
        setupTextFields()
        setupSearchButton()

        viewModel.fetchCities { [weak self] in
            DispatchQueue.main.async {
                self?.provincePickerView.reloadAllComponents()
            }
        }
    }

    func setupUI() {
        title = "Şehir ve İlçe Seçimi"
        view.backgroundColor = UIColor(white: 0.98, alpha: 1)
        navigationController?.navigationBar.tintColor = .black
    }

    func setupPickers() {
        provincePickerView.delegate = self
        provincePickerView.dataSource = self
        districtPickerView.delegate = self
        districtPickerView.dataSource = self
    }

    func setupTextFields() {
        let textFields = [provinceTextField, districtTextField]
        for field in textFields {
            field.borderStyle = .none
            field.backgroundColor = .white
            field.textColor = .black
            field.layer.cornerRadius = 12
            field.layer.shadowColor = UIColor.black.cgColor
            field.layer.shadowOpacity = 0.06
            field.layer.shadowOffset = CGSize(width: 0, height: 2)
            field.layer.shadowRadius = 3
            field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 40))
            field.leftViewMode = .always
            field.font = UIFont.systemFont(ofSize: 16)
        }

        provinceTextField.placeholder = "İl Seçiniz"
        provinceTextField.inputView = provincePickerView
        provinceTextField.inputAccessoryView = createToolbar(for: .province)
        provinceTextField.tintColor = .clear // imleç görünmesin

        provinceTextField.attributedPlaceholder = NSAttributedString(
            string: "İl Seçiniz",
            attributes: [
                .foregroundColor: UIColor.darkGray,
                .font: UIFont.systemFont(ofSize: 16)
            ]
        )

        districtTextField.placeholder = "İlçe Seçiniz"
        districtTextField.inputView = districtPickerView
        districtTextField.inputAccessoryView = createToolbar(for: .district)
        districtTextField.tintColor = .clear // imleç gizlenir, yazılamaz gibi görünür
        districtTextField.delegate = self // yazı yazmayı engellemek için

        districtTextField.attributedPlaceholder = NSAttributedString(
            string: "İlçe Seçiniz",
            attributes: [
                .foregroundColor: UIColor.darkGray,
                .font: UIFont.systemFont(ofSize: 16)
            ]
        )


        view.addSubview(provinceTextField)
        view.addSubview(districtTextField)

        provinceTextField.translatesAutoresizingMaskIntoConstraints = false
        districtTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            provinceTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            provinceTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            provinceTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            provinceTextField.heightAnchor.constraint(equalToConstant: 50),

            districtTextField.topAnchor.constraint(equalTo: provinceTextField.bottomAnchor, constant: 20),
            districtTextField.leadingAnchor.constraint(equalTo: provinceTextField.leadingAnchor),
            districtTextField.trailingAnchor.constraint(equalTo: provinceTextField.trailingAnchor),
            districtTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func setupSearchButton() {
        let searchButton = UIButton(type: .system)
        searchButton.setTitle("\u{1F50D} Nöbetçi Eczane Ara", for: .normal)
        searchButton.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1)
        searchButton.tintColor = .white
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        searchButton.layer.cornerRadius = 14
        searchButton.layer.shadowColor = UIColor.black.cgColor
        searchButton.layer.shadowOpacity = 0.1
        searchButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        searchButton.layer.shadowRadius = 5
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)

        view.addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: districtTextField.bottomAnchor, constant: 40),
            searchButton.leadingAnchor.constraint(equalTo: districtTextField.leadingAnchor),
            searchButton.trailingAnchor.constraint(equalTo: districtTextField.trailingAnchor),
            searchButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }

    @objc func searchButtonTapped() {
        _ = provincePickerView.selectedRow(inComponent: 0)
        let selectedDistrictIndex = districtPickerView.selectedRow(inComponent: 0)

        let selectedCity = viewModel.selectedCitySlug()
        let selectedDistrict = viewModel.districtSlug(at: selectedDistrictIndex)

        if selectedCity == nil || selectedCity?.isEmpty == true {
            showAlert(title: "Uyarı", message: "Lütfen önce bir il seçiniz.")
            return
        }

        if selectedDistrict == nil || selectedDistrict?.isEmpty == true {
            showAlert(title: "Uyarı", message: "Lütfen bir ilçe seçiniz.")
            return
        }

        // Her iki seçim de doğruysa devam
        print("Arama yapılıyor: İl slug = \(selectedCity!), İlçe slug = \(selectedDistrict!)")

        if let listView = storyboard?.instantiateViewController(withIdentifier: "ListView") as? ListView {
            listView.selectedProvince = selectedCity
            listView.selectedDistrict = selectedDistrict
            let nav = UINavigationController(rootViewController: listView)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
        // Rengi UIAlertController gösterildikten sonra değiştirmek gerekiyor:
            alert.view.tintColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1) // koyu kırmızı
    }


    func createToolbar(for pickerType: PickerType) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton: UIBarButtonItem

        switch pickerType {
        case .province:
            doneButton = UIBarButtonItem(title: "Seç", style: .plain, target: self, action: #selector(doneProvincePicker))
        case .district:
            doneButton = UIBarButtonItem(title: "Seç", style: .plain, target: self, action: #selector(doneDistrictPicker))
        }
        doneButton.tintColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1)
        toolbar.setItems([flexSpace, doneButton], animated: true)
        return toolbar
    }

    @objc func doneProvincePicker() {
        view.endEditing(true)
        print("İl seçimi tamamlandı: \(provinceTextField.text ?? "")")
        viewModel.fetchDistricts { [weak self] in
            DispatchQueue.main.async {
                self?.districtTextField.isUserInteractionEnabled = true
                self?.districtPickerView.reloadAllComponents()
                self?.districtTextField.text = nil
                print("İlçeler yüklendi ve picker güncellendi.")
            }
        }
    }

    @objc func doneDistrictPicker() {
        view.endEditing(true)
        print("İlçe seçimi tamamlandı: \(districtTextField.text ?? "")")
    }

    enum PickerType {
        case province, district
    }
}

extension UserInputView: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == provincePickerView {
            return viewModel.provinces().count
        } else {
            return viewModel.districtsForSelectedCity().count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == provincePickerView {
            return viewModel.provinces()[row]
        } else {
            return viewModel.districtsForSelectedCity()[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == provincePickerView {
            provinceTextField.text = viewModel.provinces()[row]
            viewModel.selectCity(at: row)
            print("Picker: İl seçildi: \(provinceTextField.text ?? "")")
            viewModel.fetchDistricts { [weak self] in
                DispatchQueue.main.async {
                    self?.districtTextField.isUserInteractionEnabled = true
                    self?.districtPickerView.reloadAllComponents()
                    self?.districtTextField.text = nil
                    print("Picker: İlçe picker güncellendi.")
                }
            }
        } else {
            let districts = viewModel.districtsForSelectedCity()
            guard row < districts.count else {
                districtTextField.text = nil
                return
            }
            districtTextField.text = districts[row]
            print("Picker: İlçe seçildi: \(districtTextField.text ?? "")")
        }
    }
}
