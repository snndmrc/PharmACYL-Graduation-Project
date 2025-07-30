import UIKit

class PharmacyCell: UITableViewCell {
    
    private let cardView = UIView()
    private let nameLabel = UILabel()
    private let addressLabel = UILabel()
    private let phoneButton = UIButton(type: .system)
    private var currentPhone: String?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // 📦 Kart görünüm
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 16
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        contentView.addSubview(cardView)

        // 🔤 Etiketler ve buton
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        nameLabel.textColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1) // koyu kırmızı

        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.font = UIFont.systemFont(ofSize: 14)
        addressLabel.textColor = .darkGray
        addressLabel.numberOfLines = 0

        phoneButton.translatesAutoresizingMaskIntoConstraints = false
        phoneButton.setTitleColor(.black, for: .normal)
        phoneButton.tintColor = .black
        phoneButton.titleLabel?.font = .systemFont(ofSize: 14)
        phoneButton.contentHorizontalAlignment = .left
        phoneButton.setImage(UIImage(systemName: "phone.fill"), for: .normal)
        phoneButton.addTarget(self, action: #selector(callPharmacy), for: .touchUpInside)

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(copyPhoneNumber(_:)))
        longPress.minimumPressDuration = 0.3
        phoneButton.addGestureRecognizer(longPress)

        // ➕ Kartın içine ekle
        cardView.addSubview(nameLabel)
        cardView.addSubview(addressLabel)
        cardView.addSubview(phoneButton)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            nameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            addressLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            addressLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            phoneButton.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 8),
            phoneButton.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            phoneButton.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            phoneButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            phoneButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    func configure(with pharmacy: Pharmacy) {
        nameLabel.text = pharmacy.pharmacyName
        addressLabel.text = pharmacy.address
        currentPhone = pharmacy.phone

        if let phone = pharmacy.phone, !phone.isEmpty {
            phoneButton.setTitle(" \(phone)", for: .normal)
            phoneButton.accessibilityLabel = "Telefon: \(phone)"
            phoneButton.isHidden = false
        } else {
            phoneButton.setTitle(nil, for: .normal)
            phoneButton.isHidden = true
        }
    }

    @objc private func callPharmacy() {
        guard let phone = currentPhone else { return }
        let cleaned = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if let url = URL(string: "tel://\(cleaned)") {
            UIApplication.shared.open(url)
        }
    }

    @objc private func copyPhoneNumber(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began, let phone = currentPhone else { return }
        UIPasteboard.general.string = phone
        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(.success)
    }
}
