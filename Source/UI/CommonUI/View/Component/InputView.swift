import UIKit

class InputView: UIView {

    // MARK: - Properties

    weak var delegate: TextFieldViewDelegate?
    private(set) var style: CellTextFieldStyle?
    private(set) lazy var iconViewWidthAnchor = iconView.widthAnchor.constraint(equalToConstant: 32)

    // MARK: - UI elements

    private lazy var stackView: UIStackView = {
      let view = UIStackView().disabledAutoresizingIntoConstraints()
      view.axis = .vertical
      view.spacing = Constants.Padding.xs.rawValue
      return view
    }()

    private(set) lazy var headerLabel: LabelView = {
        LabelView().disabledAutoresizingIntoConstraints()
    }()

    private(set) lazy var mandatoryLabel: LabelView = {
        LabelView().disabledAutoresizingIntoConstraints()
    }()

    private(set) lazy var hintLabel: LabelView = {
        LabelView().disabledAutoresizingIntoConstraints()
    }()

    private(set) lazy var textFieldContainer: UIStackView = {
        let view = UIStackView().disabledAutoresizingIntoConstraints()
        view.axis = .horizontal
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        view.spacing = 16
        view.backgroundColor = .clear
        return view
    }()

    private(set) lazy var textFieldView: TextFieldView = {
        let view = TextFieldView().disabledAutoresizingIntoConstraints()
        view.delegate = self
        return view
    }()

    private lazy var iconView: ImageContainerView = {
        let view = ImageContainerView().disabledAutoresizingIntoConstraints()
        view.isHidden = true
        return view
    }()

    override init(frame: CGRect) {
      super.init(frame: frame)
      setupViewsInOrder()
      /// Tap Gesture to dismiss the keyboard on touch on view without canceling touches In current view
      addGestureRecognizer(UIView.keyboardDismissTapGesture)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func textFieldEditingChanged(textField: UITextField) {
        delegate?.textFieldShouldChangeCharactersIn(textField: textField, replacementString: "")
    }

    private(set) lazy var errorView: SimpleErrorView = {
        SimpleErrorView().disabledAutoresizingIntoConstraints()
    }()

    // MARK: - Update subviews style

    func update(style: CellTextFieldStyle? = nil, image: UIImage? = nil, animated: Bool = false) {
        updateTextFieldContainer(image: image, animated: animated)

        guard let style = style else { return }
        self.style = style
        backgroundColor = style.backgroundColor

        mandatoryLabel.isHidden = style.isMandatory
        headerLabel.isHidden = style.title == nil
        hintLabel.isHidden = style.hint == nil

        headerLabel.update(with: style.title)
        mandatoryLabel.update(with: style.mandatory)
        hintLabel.update(with: style.hint)
        updateTextFieldContainer(style: style)
        textFieldView.update(with: style.textfield)
        updateErrorView(style: style)
    }

    private func updateTextFieldContainer(style: CellTextFieldStyle) {
        let borderColor = !(style.error?.isHidden ?? true) ?
        style.textfield.errorBorderColor.cgColor :
        style.textfield.normalBorderColor.cgColor

        textFieldContainer.layer.borderColor = borderColor
        textFieldContainer.layer.cornerRadius = style.textfield.cornerRadius
        textFieldContainer.layer.borderWidth = style.textfield.borderWidth
        textFieldContainer.backgroundColor = style.textfield.backgroundColor
    }

    private func updateTextFieldContainer(image: UIImage?, animated: Bool) {
        iconView.isHidden = image == nil
        iconView.update(with: image, animated: animated)
    }

    private func updateErrorView(style: CellTextFieldStyle) {
        errorView.update(style: style.error)
        errorView.isHidden = style.error?.isHidden ?? false
    }
}

// MARK: - Views Layout Constraint

extension InputView {

    private func setupViewsInOrder() {
        backgroundColor = style?.backgroundColor
        setupStackView()
        setupMandatoryLabel()
        setupIcon()
        setupTextField()
    }

    private func setupStackView() {
        addSubview(stackView)
        let arrangedSubviews = [
            headerLabel,
            hintLabel,
            textFieldContainer,
            errorView
        ]
        stackView.addArrangedSubviews(arrangedSubviews)
        stackView.setupConstraintEqualTo(view: self)
    }

    private func setupMandatoryLabel() {
        addSubview(mandatoryLabel)
        NSLayoutConstraint.activate([
            mandatoryLabel.topAnchor.constraint(equalTo: stackView.topAnchor),
            mandatoryLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
        mandatoryLabel.bringSubviewToFront(self)
    }

    private func setupIcon() {
        textFieldContainer.addArrangedSubview(iconView)

        NSLayoutConstraint.activate([
            iconViewWidthAnchor
        ])
    }

    private func setupTextField() {
        let heightStyle = style?.textfield.height ?? Constants.Style.BillingForm.InputTextField.height.rawValue
        textFieldContainer.addArrangedSubview(textFieldView)
        NSLayoutConstraint.activate([
            textFieldView.heightAnchor.constraint(equalToConstant: heightStyle)
        ])
    }

}

// MARK: - Text Field Delegate

extension InputView: TextFieldViewDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        delegate?.textField(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }

    func textFieldShouldBeginEditing(textField: UITextField) {
        delegate?.textFieldShouldBeginEditing(textField: textField)
        textFieldContainer.layer.borderColor = style?.textfield.focusBorderColor.cgColor
    }

    func textFieldShouldReturn() -> Bool {
         delegate?.textFieldShouldReturn() ?? false
    }

    func textFieldShouldEndEditing(textField: UITextField, replacementString: String) -> Bool {
        let shouldEndEditing = delegate?.textFieldShouldEndEditing(textField: textField, replacementString: replacementString) ?? true
        if shouldEndEditing {
            textFieldContainer.layer.borderColor = (style?.error?.isHidden ?? true) ?
                style?.textfield.normalBorderColor.cgColor :
                style?.textfield.errorBorderColor.cgColor
        }
        return shouldEndEditing
    }

    func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String) {
        delegate?.textFieldShouldChangeCharactersIn(textField: textField, replacementString: string)
    }
}