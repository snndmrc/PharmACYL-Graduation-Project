    import UIKit

    class OnboardingPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

        private let pagesContent: [(animation: String, title: String, description: String)] = [
            ("welcome", "Hoşgeldiniz!", "Nöbetçi eczaneleri kolayca bulun."),
            ("find", "Kolay Arama", "İl ve ilçeye göre arayın."),
            ("access", "Hızlı Erişim", "En yakın eczaneleri hızlıca görüntüleyin.")
        ]

        private var pages = [OnboardingContentViewController]()
        private let pageControl = UIPageControl()

        override func viewDidLoad() {
            super.viewDidLoad()

            dataSource = self
            delegate = self
            view.backgroundColor = .white

            for (index, content) in pagesContent.enumerated() {
                let vc = OnboardingContentViewController()
                vc.animationName = content.animation
                vc.titleText = content.title
                vc.descriptionText = content.description
                vc.isLastPage = (index == pagesContent.count - 1)
                pages.append(vc)
            }

            if let firstVC = pages.first {
                setViewControllers([firstVC], direction: .forward, animated: true)
            }

            setupPageControl()

            NotificationCenter.default.addObserver(self, selector: #selector(finishOnboarding), name: Notification.Name("DidFinishOnboarding"), object: nil)
        }

        private func setupPageControl() {
            pageControl.numberOfPages = pagesContent.count
            pageControl.currentPage = 0
            pageControl.pageIndicatorTintColor = .systemGray4
            pageControl.currentPageIndicatorTintColor = .systemRed
            pageControl.translatesAutoresizingMaskIntoConstraints = false

            view.addSubview(pageControl)

            NSLayoutConstraint.activate([
                pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
                pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }

        // MARK: - UIPageViewControllerDataSource

        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = pages.firstIndex(of: viewController as! OnboardingContentViewController), index > 0 else {
                return nil
            }
            return pages[index - 1]
        }

        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = pages.firstIndex(of: viewController as! OnboardingContentViewController), index < pages.count - 1 else {
                return nil
            }
            return pages[index + 1]
        }

        // MARK: - UIPageViewControllerDelegate

        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
                                previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed, let visibleVC = viewControllers?.first as? OnboardingContentViewController,
               let index = pages.firstIndex(of: visibleVC) {
                pageControl.currentPage = index
            }
        }

        // MARK: - Onboarding bittiğinde welcome’a geçiş

        @objc private func finishOnboarding() {
            UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
            UserDefaults.standard.synchronize()

            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else {
                return
            }


            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let welcomeVC = storyboard.instantiateViewController(withIdentifier: "WelcomeView")

            UIView.transition(with: window, duration: 0.7, options: [.transitionFlipFromRight], animations: {
                window.rootViewController = welcomeVC
            })
        }
    }
