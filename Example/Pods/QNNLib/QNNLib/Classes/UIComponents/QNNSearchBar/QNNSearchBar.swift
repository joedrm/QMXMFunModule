//
//  QNNSearchBar.swift
//  QNN
//
//  Created by wdy on 2018/9/3.
//  Copyright © 2018年 qianshengqian. All rights reserved.
//

import UIKit
import SnapKit


public class QNNSearchBar: UIView, QNNSearchBarDelegate {
    
    var textBeforeEditing: String?
    var bgToCancelButtonConstraint: NSLayoutConstraint!
    var bgToParentConstraint: NSLayoutConstraint!
    let backgroundView: UIImageView = UIImageView()
    let cancelButton: UIButton = UIButton(type: .custom)
    public let textField: UITextField
    
    public var config: QNNSearchBarConfig {
        didSet {
            if let textField = textField as? QNNSearchBarTextField  {
                textField.config = config
            }
            updateUserInterface()
            updateViewConstraints()
        }
    }

    public var isActive: Bool = true {
        didSet {
            updateUserInterface()
        }
    }

    public var text: String? {set {textField.text = newValue} get {return textField.text}}
    public var placeholder: String? {set {textField.placeholder = newValue} get {return textField.placeholder}}
    public var textAlignment: NSTextAlignment {set {textField.textAlignment = newValue} get {return textField.textAlignment}}
    public var isEnabled: Bool {set {textField.isEnabled = newValue} get {return textField.isEnabled}}
    public weak var delegate: QNNSearchBarDelegate?

    
    // MARK: - Lifecycle

    public init(config: QNNSearchBarConfig) {
        self.config = config
        self.textField = QNNSearchBarTextField(config: config)

        super.init(frame: CGRect.zero)

        self.delegate = self
        translatesAutoresizingMaskIntoConstraints = false

        setupBackgroundView(withConfig: config)
        setupTextField(withConfig: config)
        setupCancelButton(withConfig: config)

        backgroundView.addSubview(textField)
        addSubview(cancelButton)
        addSubview(backgroundView)

        updateViewConstraints()

        updateUserInterface()
    }

    func setupBackgroundView(withConfig config: QNNSearchBarConfig) {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.isUserInteractionEnabled = true
        updateBackgroundImage(withRadius: 0, corners: .allCorners, color: UIColor.white)
    }

    func setupTextField(withConfig config: QNNSearchBarConfig) {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.autocorrectionType = .default
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        textField.adjustsFontSizeToFitWidth = false
        textField.clipsToBounds = true
        textField.addTarget(self, action: #selector(didChangeTextField(_:)), for: .editingChanged)
    }

    func setupCancelButton(withConfig config: QNNSearchBarConfig) {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.alpha = 0.0
        cancelButton.setContentHuggingPriority(.required, for: .horizontal)
        cancelButton.reversesTitleShadowWhenHighlighted = true
        cancelButton.adjustsImageWhenHighlighted = true
        cancelButton.addTarget(self, action: #selector(pressedCancelButton(_:)), for: .touchUpInside)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateViewConstraints() {
        let isInitialUpdate = backgroundView.constraints.isEmpty
        let isTextFieldInEditMode = bgToCancelButtonConstraint?.isActive ?? false

        bgToParentConstraint?.isActive = false
        bgToCancelButtonConstraint?.isActive = false

        if isInitialUpdate {
            if #available(iOS 9.0, *) {
                let constraints = [
                    backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    backgroundView.topAnchor.constraint(equalTo: topAnchor),
                    backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
                    
                    textField.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
                    textField.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
                    textField.topAnchor.constraint(equalTo: backgroundView.topAnchor),
                    textField.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
                    
                    cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor),
                    cancelButton.topAnchor.constraint(equalTo: topAnchor),
                    cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor),
                    ]
                NSLayoutConstraint.activate(constraints)
                
                bgToParentConstraint = backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor)
                bgToCancelButtonConstraint = backgroundView.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -config.rasterSize)
            } else {
                
            }
        }

        bgToCancelButtonConstraint.constant = -config.rasterSize

        if isTextFieldInEditMode && !isInitialUpdate && config.useCancelButton {
            bgToCancelButtonConstraint.isActive = true
        } else {
            bgToParentConstraint.isActive = true
        }
    }


    // MARK: - First Responder Handling

    public override var isFirstResponder: Bool {
        return textField.isFirstResponder
    }

    @discardableResult
    public override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }

    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }

    public override var canResignFirstResponder: Bool {
        return textField.canResignFirstResponder
    }

    public override var canBecomeFirstResponder: Bool {
        return textField.canBecomeFirstResponder
    }


    // MARK: - UI Updates

    func updateUserInterface() {
        var textColor = config.textAttributes[.foregroundColor] as? UIColor ?? QNNSearchBarConfig.defaultTextForegroundColor

        // Replace normal color with a lighter color so the text looks disabled
        if !isActive { textColor = textColor.withAlphaComponent(0.5) }

        textField.tintColor = textColor // set cursor color
        textField.textColor = textColor

        textField.leftView = config.leftView
        textField.leftViewMode = config.leftViewMode

        textField.rightView = config.rightView
        textField.rightViewMode = config.rightViewMode

        textField.clearButtonMode = config.clearButtonMode

        var textAttributes = config.textAttributes
        textAttributes[.foregroundColor] = textColor
        
        // warning
        textField.defaultTextAttributes = textAttributes 

        let normalAttributes = config.cancelButtonTextAttributes
        cancelButton.setAttributedTitle(NSAttributedString(string: config.cancelButtonTitle, attributes: normalAttributes), for: .normal)
        var highlightedAttributes = config.cancelButtonTextAttributes
        let highlightColor = highlightedAttributes[.foregroundColor] as? UIColor ?? QNNSearchBarConfig.defaultTextForegroundColor
        highlightedAttributes[.foregroundColor] = highlightColor.withAlphaComponent(0.75)
        cancelButton.setAttributedTitle(NSAttributedString(string: config.cancelButtonTitle, attributes: highlightedAttributes), for: .highlighted)

        if #available(iOS 10.0, *) {
            if let textContentType = config.textContentType {
                textField.textContentType = UITextContentType(rawValue: textContentType)
            }
        }
    }

    public func updateBackgroundImage(withRadius radius: CGFloat, corners: UIRectCorner, color: UIColor) {
        let insets = UIEdgeInsets(top: radius, left: radius, bottom: radius, right: radius)
        let imgSize = CGSize(width: radius*2 + 1, height: radius*2 + 1)
        var img = UIImage.imageWithSolidColor(color, size: imgSize)
        img = img.roundedImage(with: radius, cornersToRound: corners)
        img = img.resizableImage(withCapInsets: insets)
        backgroundView.image = img
        backgroundColor = UIColor.clear
    }


    func resetTextField() {
        let oldText = textField.text
        textField.text = textBeforeEditing
        if oldText != textField.text {
            delegate?.searchBar(self, textDidChange: "")
        }
    }

    
    // MARK: - Cancel Button Management
    public func cancelSearch() {

        let shouldCancel = delegate?.searchBarShouldCancel(self) ?? searchBarShouldCancel(self)
        if shouldCancel {
            resetTextField()
            textField.resignFirstResponder()
        }
    }

    @objc func pressedCancelButton(_ sender: AnyObject) {

        cancelSearch()
    }

    func updateCancelButtonVisibility(makeVisible show: Bool) {

        if show && config.useCancelButton {
            bgToParentConstraint.isActive = false
            bgToCancelButtonConstraint.isActive = true
        } else {
            bgToCancelButtonConstraint.isActive = false
            bgToParentConstraint.isActive = true
        }

        UIView.animate(withDuration: config.animationDuration, delay: 0, options: [], animations: {
            self.layoutIfNeeded()
            self.cancelButton.alpha = show ? 1 : 0
        }, completion: nil)
    }

    
    @objc func didChangeTextField(_ textField: UITextField) {

        let newText = textField.text ?? ""
        delegate?.searchBar(self, textDidChange: newText)
    }
}


// MARK: - UITextFieldDelegate

extension QNNSearchBar: UITextFieldDelegate {

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let shouldBegin = delegate?.searchBarShouldBeginEditing(self) ?? searchBarShouldBeginEditing(self)
        if shouldBegin {
            updateCancelButtonVisibility(makeVisible: true)
        }
        return shouldBegin
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textBeforeEditing = textField.text
        delegate?.searchBarDidBeginEditing(self)
    }

    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let shouldEnd = delegate?.searchBarShouldEndEditing(self) ?? searchBarShouldEndEditing(self)
        if shouldEnd {
            updateCancelButtonVisibility(makeVisible: false)
        }
        return shouldEnd
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.searchBarDidEndEditing(self)
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let shouldChange = delegate?.searchBar(self, shouldChangeCharactersIn: range, replacementString: string) ?? searchBar(self, shouldChangeCharactersIn: range, replacementString: string)
        return shouldChange
    }

    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        let shouldClear = delegate?.searchBarShouldClear(self) ?? searchBarShouldClear(self)
        return shouldClear
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let shouldReturn = delegate?.searchBarShouldReturn(self) ?? searchBarShouldReturn(self)
        return shouldReturn
    }
}
