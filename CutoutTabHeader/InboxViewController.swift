import UIKit

class InboxViewController: UIViewController {

    static let createView: (UIColor) -> UIView = { color in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color
        return view
    }

    let titles = ["One", "Two"]//, "Three", "Four"]

    let leftButton = UIBarButtonItem(barButtonSystemItem: .camera, target: nil, action: nil)
    let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    lazy var header = SlidingHeaderView(titles: titles, initialColor: Layout.colors[0])
    lazy var views = titles.enumerated().map { InboxViewController.createView(Layout.colors[$0.offset]) }
    lazy var colors = titles.enumerated().map { Layout.colors[$0.offset].rgb }

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
        header.heightAnchor.constraint(equalToConstant: SlidingHeaderView.tabHeight).isActive = true
        
        scrollView.frame = CGRect(
            x: 0,
            y: SlidingHeaderView.tabHeight,
            width: Layout.viewWidth,
            height: Layout.viewHeight - SlidingHeaderView.tabHeight
        )

        views.enumerated().forEach {
            scrollView.addSubview($0.element)
            $0.element.frame = CGRect(
                x: CGFloat($0.offset) * Layout.viewWidth,
                y: 0,
                width: Layout.viewWidth,
                height: Layout.viewHeight - SlidingHeaderView.tabHeight
            )
        }
        
        scrollView.contentSize = CGSize(
            width: Layout.viewWidth * CGFloat(views.count),
            height: Layout.viewHeight - SlidingHeaderView.tabHeight
        )

        leftButton.tintColor = Layout.colors[0]
        rightButton.tintColor = Layout.colors[0]
        header.buttons.forEach { $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedButton(sender:)))) }
        scrollView.delegate = self
    }
    
    @objc func tappedButton(sender: UITapGestureRecognizer) {
        guard let button = sender.view as? UIImageView else { return }
        let index = CGFloat(header.buttons.index(of: button) ?? 0)

        scrollView.setContentOffset(CGPoint(x: index * Layout.viewWidth, y: 0), animated: true)
    }
}

extension InboxViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let numberOfTabs = CGFloat(titles.count)
        let maxOffset = Layout.viewWidth - (Layout.viewWidth / numberOfTabs)
        let headerOffset = (scrollView.contentOffset.x / numberOfTabs)
            .keepBetween(min: 0, max: maxOffset)

        header.headerLineConstraint.constant = headerOffset

        let currentPage = Int(floor((scrollView.contentOffset.x + Layout.viewWidth) / Layout.viewWidth))
            .keepBetween(min: 1, max: titles.count - 1)

        let leftColor = colors[currentPage - 1]
        let rightColor = colors[currentPage]

        let maxRedDelta = rightColor.red - leftColor.red
        let maxGreenDelta = rightColor.green - leftColor.green
        let maxBlueDelta = rightColor.blue - leftColor.blue

        let percentage = (scrollView.contentOffset.x / Layout.viewWidth) - CGFloat(currentPage - 1)

        let color = UIColor(
            red: percentage * maxRedDelta + leftColor.red,
            green: percentage * maxGreenDelta + leftColor.green,
            blue: percentage * maxBlueDelta + leftColor.blue,
            alpha: 1
        )
        header.headerSlider.backgroundColor = color
        leftButton.tintColor = color
        rightButton.tintColor = color

        print("scrollViewOffset: ", scrollView.contentOffset)
        print("numberOfTabs: ", numberOfTabs)
        print("maxOffset: ", maxOffset)
        print("headerOffset: ", headerOffset)
        print("currentPage: ", currentPage)
        print("leftColor: ", leftColor)
        print("rightColor: ", rightColor)
        print("maxRedDelta: ", maxRedDelta)
        print("maxGreenDelta: ", maxGreenDelta)
        print("maxBlueDelta: ", maxBlueDelta)
        print("percentage: ", percentage)
        print("color: ", color)
        print("\n\n")
    }
}
