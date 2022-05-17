import UIKit

struct DefaultHintInputLabelStyle: CKOLabelStyle {
    var isHidden: Bool
    var text: String
    var font: UIFont
    var textColor: UIColor
    
    init(isHidden: Bool = false,
         text: String = "",
         font: UIFont = UIFont(graphikStyle: .regular, size: 13),
         textColor: UIColor = .doveGray) {
        self.isHidden = isHidden
        self.text = text
        self.font = font
        self.textColor = textColor
    }
}
