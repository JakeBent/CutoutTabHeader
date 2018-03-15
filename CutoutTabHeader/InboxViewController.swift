import UIKit

class InboxViewController: UIViewController {

    static let createView: (UIColor) -> UIView = { color in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color
        return view
    }

    let titles = ["One", "Two", "Three", "Four", "Five", "Six", "Seven"]
    let colors: [UIColor] = [.bhBlue, .bhDarkBlue, .bhPurple, .bhRed, .bhOrange, .bhYellow, .bhGreen]


    let leftButton = UIBarButtonItem(barButtonSystemItem: .camera, target: nil, action: nil)
    let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    lazy var header = CutoutTabHeader(initialColor: colors[0])
    lazy var views = titles.enumerated().map { InboxViewController.createView(colors[$0.offset]) }

    let scrollView: UIScrollView = {
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

        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton

        view.backgroundColor = .white
        view.addSubview(scrollView)
        view.addSubview(header)
        
        header.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        header.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        header.heightAnchor.constraint(equalToConstant: CutoutTabHeader.tabHeight).isActive = true
        
        scrollView.frame = CGRect(
            x: 0,
            y: CutoutTabHeader.tabHeight,
            width: Layout.viewWidth,
            height: Layout.viewHeight - CutoutTabHeader.tabHeight
        )

        views.enumerated().forEach {
            scrollView.addSubview($0.element)
            $0.element.frame = CGRect(
                x: CGFloat($0.offset) * Layout.viewWidth,
                y: 0,
                width: Layout.viewWidth,
                height: Layout.viewHeight - CutoutTabHeader.tabHeight
            )
        }
        
        scrollView.contentSize = CGSize(
            width: Layout.viewWidth * CGFloat(views.count),
            height: Layout.viewHeight - CutoutTabHeader.tabHeight
        )

        leftButton.tintColor = colors[0]
        rightButton.tintColor = colors[0]
        scrollView.delegate = self
        header.tabDelegate = self
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
}

extension InboxViewController: UIScrollViewDelegate, CutoutTabHeaderDelegate {
    var fullPageScrollView: UIScrollView { return scrollView }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let color = header.fullPageViewDidScroll(scrollView)
        leftButton.tintColor = color
        rightButton.tintColor = color
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
