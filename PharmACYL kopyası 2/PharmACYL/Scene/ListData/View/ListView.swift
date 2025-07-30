import UIKit
import MapKit

class ListView: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var selectedProvince: String? // slug: örneğin "ankara"
    var selectedDistrict: String? // slug: örneğin "cankaya"

    private let viewModel = ListViewModel()
    private let tableView = UITableView()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Yükleniyor..."
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        fetchPharmacies()
    }

    private func setupUI() {
        title = "Nöbetçi Eczaneler"
        view.backgroundColor = .systemBackground

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PharmacyCell.self, forCellReuseIdentifier: "PharmacyCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        view.addSubview(tableView)
        view.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func fetchPharmacies() {
        guard let provinceSlug = selectedProvince,
              let districtSlug = selectedDistrict else {
            print("❌ Şehir veya ilçe slug'ı yok.")
            return
        }

        print("➡️ Sluglar ile istek yapılıyor: \(provinceSlug)/\(districtSlug)")

        viewModel.fetchPharmacies(forCity: provinceSlug, districtSlug: districtSlug) {
            DispatchQueue.main.async {
                if let error = self.viewModel.errorMessage {
                    self.emptyLabel.text = error
                    self.emptyLabel.isHidden = false
                    self.tableView.isHidden = true
                } else {
                    self.emptyLabel.isHidden = true
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "PharmacyCell", for: indexPath) as? PharmacyCell,
            let pharmacy = viewModel.eczaneAtIndex(indexPath.row)
        else {
            return UITableViewCell()
        }

        cell.configure(with: pharmacy)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let pharmacy = viewModel.eczaneAtIndex(indexPath.row) else { return }

        let coordinate = CLLocationCoordinate2D(latitude: pharmacy.latitude, longitude: pharmacy.longitude)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = pharmacy.pharmacyName
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Geri", style: .plain, target: self, action: #selector(backButtonTapped))
    }

    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
