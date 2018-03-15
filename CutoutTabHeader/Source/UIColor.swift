import UIKit

extension UIColor {
    static let bhGrey = UIColor(red: 2/255, green: 57/255, blue: 74/255, alpha: 1)
    static let bhDarkBlue = UIColor(red: 4/255, green: 53/255, blue: 101/255, alpha: 1)
    static let bhBlue = UIColor(red: 81/255, green: 88/255, blue: 187/255, alpha: 1)
    static let bhPurple = UIColor(red: 242/255, green: 109/255, blue: 249/255, alpha: 1)
    static let bhPink = UIColor(red: 235/255, green: 75/255, blue: 152/255, alpha: 1)
    static let bhRed = UIColor(red: 244/255, green: 68/255, blue: 46/255, alpha: 1)
    static let bhOrange = UIColor(red: 252/255, green: 158/255, blue: 79/255, alpha: 1)
    static let bhGreen = UIColor(red: 129/255, green: 244/255, blue: 153/255, alpha: 1)
    static let bhYellow = UIColor(red: 255/255, green: 230/255, blue: 109/255, alpha: 1)

    var rgb: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: nil)

        return (red, green, blue)
    }
}
