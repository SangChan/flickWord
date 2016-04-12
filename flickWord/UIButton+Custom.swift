/*
 * "Hello Swift, Goodbye Obj-C."
 * Converted by 'objc2swift'
 *
 * https://github.com/yahoojapan/objc2swift
 */

extension UIButton {
    func defaultStyle() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 4.0
        self.layer.masksToBounds = true
        self.setAdjustsImageWhenHighlighted(false)
        self.setTitleColor(UIColor.colorWithRed(0.05, green: 0.58, blue: 0.99, alpha: 1.0), forState: UIControlStateNormal)
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderColor = UIColor.colorWithRed(0.05, green: 0.58, blue: 0.99, alpha: 1.0).CGColor()
    }
    
    func circleStyle() {
        self.defaultStyle()
        self.layer.cornerRadius = self.frame.size.width / 2
    }
    
    func grayCircleStyle() {
        self.defaultStyle()
        self.layer.cornerRadius = self.frame.size.width / 2
        self.setTitleColor(UIColor.colorWithRed(0.9, green: 0.9, blue: 0.9, alpha: 0.8), forState: UIControlStateNormal)
        self.backgroundColor = UIColor.colorWithRed(0.7, green: 0.7, blue: 0.7, alpha: 0.6)
        self.layer.borderColor = UIColor.colorWithRed(0.8, green: 0.8, blue: 0.8, alpha: 0.8).CGColor()
    }
    
    func darkCircleStyle() {
        self.defaultStyle()
        self.layer.cornerRadius = self.frame.size.width / 2
        self.setTitleColor(UIColor.colorWithRed(0.9, green: 0.9, blue: 0.9, alpha: 0.8), forState: UIControlStateNormal)
        self.backgroundColor = UIColor.colorWithRed(0.1, green: 0.1, blue: 0.1, alpha: 0.6)
        self.layer.borderColor = UIColor.colorWithRed(0.1, green: 0.1, blue: 0.1, alpha: 0.8).CGColor()
    }
    
    func setAwesomeIcon(iconID: FAIcon) {
        self.titleLabel.font = UIFont.fontWithName(kFontAwesomeFamilyName, size: self.titleLabel.font.pointSize)
        self.titleLabel.shadowOffset = CGSizeMake(0, -1)
        self.setTitle(NSString.fontAwesomeIconStringForEnum(iconID), forState: UIControlStateNormal)
    }
}
