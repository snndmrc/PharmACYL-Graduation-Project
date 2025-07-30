import UIKit
import Lottie

class OnboardingContentViewController: UIViewController {

    private let animationView = LottieAnimationView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let startButton = UIButton(type: .system)

    var animationName: String? {
        didSet {
            if let name = animationName {
                animationView.animation = LottieAnimation.named(name)
                animationView.play()
                animationView.loopMode = .loop
            }
        }
    }

    var titleText: String?
    var descriptionText: String?
    var isLastPage: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        configureContent()

        if isLastPage {
            startButton.isHidden = true // butonu gizle
            // 2 saniye sonra onboarding biter
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                NotificationCenter.default.post(name: Notification.Name("DidFinishOnboarding"), object: nil)
            }
        } else {
            startButton.isHidden = true
        }
    }

    private func setupViews() {
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit

        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.font = UIFont.systemFont(ofSize: 18)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        startButton.setTitle("Başla", for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)

        view.addSubview(animationView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(startButton)

        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.heightAnchor.constraint(equalToConstant: 250),
            animationView.widthAnchor.constraint(equalToConstant: 250),

            titleLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            startButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func configureContent() {
        titleLabel.text = titleText
        descriptionLabel.text = descriptionText
    }

    @objc private func startButtonTapped() {
        NotificationCenter.default.post(name: Notification.Name("DidFinishOnboarding"), object: nil)
    }
}
