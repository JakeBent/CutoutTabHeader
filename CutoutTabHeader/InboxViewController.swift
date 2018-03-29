import UIKit

class InboxViewController: UIViewController {

    private static let createView: (UIColor) -> UIView = { color in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color
        return view
    }

    private let titles = ["One", "Two", "Three", "Four", "Five", "Six", "Seven"]
    private let colors: [UIColor] = [.bhBlue, .bhDarkBlue, .bhPurple, .bhRed, .bhOrange, .bhYellow, .bhGreen]

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    private let leftButton = UIBarButtonItem(barButtonSystemItem: .camera, target: nil, action: nil)
    private let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    private lazy var header = CutoutTabHeader(initialColor: colors[0])
    private lazy var views = titles.enumerated().map { InboxViewController.createView(colors[$0.offset]) }


    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = titleLabel
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton

        view.backgroundColor = .white
        view.addSubview(scrollView)
        view.addSubview(header)
        
        header.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        header.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        header.heightAnchor.constraint(equalToConstant: CutoutTabHeader.tabHeight).isActive = true

        scrollView.topAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        var previousAnchor = scrollView.leftAnchor
        views.forEach { view in
            scrollView.addSubview(view)
            view.leftAnchor.constraint(equalTo: previousAnchor).isActive = true
            view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
            view.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            previousAnchor = view.rightAnchor
        }
        views[views.count - 1].rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true

        leftButton.tintColor = colors[0]
        rightButton.tintColor = colors[0]
        titleLabel.textColor = colors[0]
        scrollView.delegate = self
        header.tabDelegate = self
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
}

extension InboxViewController: UIScrollViewDelegate, CutoutTabHeaderDelegate {
    var fullPageScrollView: UIScrollView { return scrollView }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        header.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: nil) { _ in
            self.scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.width * CGFloat(self.header.currentPage - 1), y: 0), animated: true)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let color = header.fullPageViewDidScroll(scrollView)
        leftButton.tintColor = color
        rightButton.tintColor = color
        titleLabel.textColor = color
    }

    func numberOfTabs() -> Int {
        return titles.count
    }

    func titleForTab(index: Int) -> String {
        return titles[index]
    }

    func colorForTab(index: Int) -> UIColor {
        return colors[index]
    }

    func didTapTab(index: Int, completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.scrollView.contentOffset = CGPoint(x: CGFloat(index) * Layout.viewWidth, y: 0)
        }, completion: completion)
    }
}
