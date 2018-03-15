import UIKit

class SlidingHeaderView: UIView {
    
    static let tabHeight = Layout.marginStandard * 4

    static let maskedView: (String, Int) -> UIImageView = { text, numTitles in
        let numberOfTitles = CGFloat(numTitles)
        let size = CGSize(width: Layout.viewWidth / numberOfTitles, height: tabHeight - Layout.marginMedium)
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        
        let context = UIGraphicsGetCurrentContext()
        context?.scaleBy(x: 1, y: -1)
        context?.translateBy(x: 0, y: -size.height)
        
        // draw the text
        let attributes: [NSAttributedStringKey: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 14),
            .foregroundColor: UIColor.white
        ]
        let textSize = text.size(withAttributes: attributes)
        let point = CGPoint(x: (size.width - textSize.width) / 2, y: (size.height - textSize.height) / 2)
        text.draw(at: point, withAttributes: attributes)
        
        // capture the image and end context
        let maskImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // create image mask
        guard let cgimage = maskImage?.cgImage, let dataProvider = cgimage.dataProvider else { return UIImageView() }
        
        guard let mask = CGImage(
            maskWidth: cgimage.width,
            height: cgimage.height,
            bitsPerComponent: cgimage.bitsPerComponent,
            bitsPerPixel: cgimage.bitsPerPixel,
            bytesPerRow: cgimage.bytesPerRow,
            provider: dataProvider,
            decode: nil,
            shouldInterpolate: false
            ) else { return UIImageView() }
        
        // create the actual image
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIGraphicsGetCurrentContext()?.clip(to: rect, mask: mask)
        UIColor.white.withAlphaComponent(1).setFill()
        UIBezierPath(rect: rect).fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // return image
        let imageView = UIImageView(image: image)
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    let titles: [String]
    var buttons: [UIImageView] = []
    let headerBackground = InboxViewController.createView(.lightGray)
    let headerSlider = UIView()
    var headerLineConstraint: NSLayoutConstraint!
    var views: [UIView] {
        return [headerBackground, headerSlider]
    }
    
    init(titles: [String], initialColor: UIColor) {
        self.titles = titles
        super.init(frame: .zero)

        guard titles.count < 5 else { fatalError("Too many titles in the sliding header view!") }

        headerSlider.backgroundColor = initialColor
        buttons = titles.map { SlidingHeaderView.maskedView($0, titles.count) }

        clipsToBounds = false
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        
        views.forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        let widthMultiplier = 1 / CGFloat(buttons.count)

        headerSlider.topAnchor.constraint(equalTo: topAnchor).isActive = true
        headerSlider.heightAnchor.constraint(equalToConstant: SlidingHeaderView.tabHeight).isActive = true
        headerSlider.widthAnchor.constraint(equalTo: widthAnchor, multiplier: widthMultiplier).isActive = true
        headerLineConstraint = headerSlider.leftAnchor.constraint(equalTo: leftAnchor)
        headerLineConstraint.isActive = true
        
        headerBackground.leftAnchor.constraint(equalTo: leftAnchor, constant: Layout.marginMedium).isActive = true
        headerBackground.rightAnchor.constraint(equalTo: rightAnchor, constant: -Layout.marginMedium).isActive = true
        headerBackground.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        headerBackground.heightAnchor.constraint(equalToConstant: Layout.marginStandard * 2).isActive = true

        var previousAnchor: NSLayoutAnchor = leftAnchor
        buttons.forEach { button in
            addSubview(button)
            button.topAnchor.constraint(equalTo: topAnchor).isActive = true
            button.bottomAnchor.constraint(equalTo: headerSlider.bottomAnchor, constant: -Layout.marginMedium).isActive = true
            button.widthAnchor.constraint(equalToConstant: Layout.viewWidth / CGFloat(buttons.count) + 1).isActive = true
            button.leftAnchor.constraint(equalTo: previousAnchor, constant: -1).isActive = true
            previousAnchor = button.rightAnchor
        }

        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 5
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

















