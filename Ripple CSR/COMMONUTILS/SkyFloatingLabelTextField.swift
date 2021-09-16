//  Copyright 2016-2019 Skyscanner Ltd
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance 
//  with the License. You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed 
//  on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License 
//  for the specific language governing permissions and limitations under the License.

import UIKit

/**
 A beautiful and flexible textfield implementation with support for title label, error message and placeholder.
 */
@IBDesignable
open class FloatingSearchTextField: UITextField { // swiftlint:disable:this type_body_length
    /**
     A Boolean value that determines if the language displayed is LTR. 
     Default value set automatically from the application language settings.
     */
    @objc open var isLTRLanguage: Bool = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight {
        didSet {
           updateTextAligment()
        }
    }
  /// Maximum number of results to be shown in the suggestions list
     open var maxNumberOfResults = 0
     
     /// Maximum height of the results list
     open var maxResultsListHeight = 0
     
     /// Indicate if this field has been interacted with yet
     open var interactedWith = false
     
     /// Indicate if keyboard is showing or not
     open var keyboardIsShowing = false

     /// How long to wait before deciding typing has stopped
     open var typingStoppedDelay = 0.8
     
     /// Set your custom visual theme, or just choose between pre-defined SearchTextFieldTheme.lightTheme() and SearchTextFieldTheme.darkTheme() themes
     open var theme = FloatingSearchTextFieldTheme.lightTheme() {
         didSet {
             tableView?.reloadData()
             
             if let placeholderColor = theme.placeholderColor {
                 if let placeholderString = placeholder {
                     self.attributedPlaceholder = NSAttributedString(string: placeholderString, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
                 }
                 
                 self.placeholderLabel?.textColor = placeholderColor
             }
            
             if let hightlightedFont = self.highlightAttributes[.font] as? UIFont {
                 self.highlightAttributes[.font] = hightlightedFont.withSize(self.theme.font.pointSize)
             }
         }
     }
     
     /// Show the suggestions list without filter when the text field is focused
     open var startVisible = false
     
     /// Show the suggestions list without filter even if the text field is not focused
     open var startVisibleWithoutInteraction = false {
         didSet {
             if startVisibleWithoutInteraction {
                 textFieldDidChange()
             }
         }
     }
     
     /// Set an array of SearchTextFieldItem's to be used for suggestions
     open func filterItems(_ items: [SearchTextFieldItem]) {
         filterDataSource = items
     }
     
     /// Set an array of strings to be used for suggestions
     open func filterStrings(_ strings: [String]) {
         var items = [SearchTextFieldItem]()
         
         for value in strings {
             items.append(SearchTextFieldItem(title: value))
         }
         
         filterItems(items)
     }
     
     /// Closure to handle when the user pick an item
     open var itemSelectionHandler: SearchTextFieldItemHandler?
     
     /// Closure to handle when the user stops typing
     open var userStoppedTypingHandler: (() -> Void)?
     
     /// Set your custom set of attributes in order to highlight the string found in each item
     open var highlightAttributes: [NSAttributedString.Key: AnyObject] = [.font: UIFont.boldSystemFont(ofSize: 10)]
     
     /// Start showing the default loading indicator, useful for searches that take some time.
     open func showLoadingIndicator() {
         self.rightViewMode = .always
         indicator.startAnimating()
     }
     
     /// Force the results list to adapt to RTL languages
     open var forceRightToLeft = false
     
     /// Hide the default loading indicator
     open func stopLoadingIndicator() {
         self.rightViewMode = .never
         indicator.stopAnimating()
     }
     
     /// When InlineMode is true, the suggestions appear in the same line than the entered string. It's useful for email domains suggestion for example.
     open var inlineMode: Bool = false {
         didSet {
             if inlineMode == true {
                 autocorrectionType = .no
                 spellCheckingType = .no
             }
         }
     }
     
     /// Only valid when InlineMode is true. The suggestions appear after typing the provided string (or even better a character like '@')
     open var startFilteringAfter: String?
     
     /// Min number of characters to start filtering
     open var minCharactersNumberToStartFiltering: Int = 0

     /// Force no filtering (display the entire filtered data source)
     open var forceNoFiltering: Bool = false
     
     /// If startFilteringAfter is set, and startSuggestingImmediately is true, the list of suggestions appear immediately
     open var startSuggestingImmediately = false
     
     /// Allow to decide the comparision options
     open var comparisonOptions: NSString.CompareOptions = [.caseInsensitive]
     
     /// Set the results list's header
     open var resultsListHeader: UIView?

     // Move the table around to customize for your layout
     open var tableXOffset: CGFloat = 0.0
     open var tableYOffset: CGFloat = 0.0
     open var tableCornerRadius: CGFloat = 2.0
     open var tableBottomMargin: CGFloat = 10.0
     
     ////////////////////////////////////////////////////////////////////////
     // Private implementation
     
     fileprivate var tableView: UITableView?
     fileprivate var shadowView: UIView?
     fileprivate var direction: Direction = .down
     fileprivate var fontConversionRate: CGFloat = 0.7
     fileprivate var keyboardFrame: CGRect?
     fileprivate var timer: Timer? = nil
     fileprivate var placeholderLabel: UILabel?
     fileprivate static let cellIdentifier = "APSearchTextFieldCell"
     fileprivate let indicator = UIActivityIndicatorView(style: .gray)
     fileprivate var maxTableViewSize: CGFloat = 0
     
     var filteredResults = [SearchTextFieldItem]()
     fileprivate var filterDataSource = [SearchTextFieldItem]() {
         didSet {
             filter(forceShowAll: forceNoFiltering)
             buildSearchTableView()
             
             if startVisibleWithoutInteraction {
                 editingChanged()
             }
         }
     }
     
     fileprivate var currentInlineItem = ""
     
     deinit {
         NotificationCenter.default.removeObserver(self)
     }
     
     open override func willMove(toWindow newWindow: UIWindow?) {
         super.willMove(toWindow: newWindow)
         tableView?.removeFromSuperview()
     }
    fileprivate func updateTextAligment() {
        if isLTRLanguage {
            textAlignment = .left
            titleLabel.textAlignment = .left
        } else {
            textAlignment = .right
            titleLabel.textAlignment = .right
        }
    }

    // MARK: Animation timing

    /// The value of the title appearing duration
    @objc dynamic open var titleFadeInDuration: TimeInterval = 0.2
    /// The value of the title disappearing duration
    @objc dynamic open var titleFadeOutDuration: TimeInterval = 0.3

    // MARK: Colors

    fileprivate var cachedTextColor: UIColor?

    /// A UIColor value that determines the text color of the editable text
    @IBInspectable
    override dynamic open var textColor: UIColor? {
        set {
            cachedTextColor = newValue
            updateControl(false)
        }
        get {
            return cachedTextColor
        }
    }

    /// A UIColor value that determines text color of the placeholder label
    @IBInspectable dynamic open var placeholderColor: UIColor = UIColor.lightGray {
        didSet {
            updatePlaceholder()
        }
    }

    /// A UIFont value that determines text color of the placeholder label
    @objc dynamic open var placeholderFont: UIFont? {
        didSet {
            updatePlaceholder()
        }
    }

    fileprivate func updatePlaceholder() {
        guard let placeholder = placeholder, let font = placeholderFont ?? font else {
            return
        }
        let color = isEnabled ? placeholderColor : disabledColor
        #if swift(>=4.2)
            attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [
                    NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font
                ]
            )
        #elseif swift(>=4.0)
            attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [
                    NSAttributedStringKey.foregroundColor: color, NSAttributedStringKey.font: font
                ]
            )
        #else
            attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSForegroundColorAttributeName: color, NSFontAttributeName: font]
            )
        #endif
    }

    /// A UIFont value that determines the text font of the title label
    @objc dynamic open var titleFont: UIFont = .systemFont(ofSize: 13) {
        didSet {
            updateTitleLabel()
        }
    }

    /// A UIColor value that determines the text color of the title label when in the normal state
    @IBInspectable dynamic open var titleColor: UIColor = .gray {
        didSet {
            updateTitleColor()
        }
    }

    /// A UIColor value that determines the color of the bottom line when in the normal state
    @IBInspectable dynamic open var lineColor: UIColor = .lightGray {
        didSet {
            updateLineView()
        }
    }

    /// A UIColor value that determines the color used for the title label and line when the error message is not `nil`
    @IBInspectable dynamic open var errorColor: UIColor = .red {
        didSet {
            updateColors()
        }
    }

    /// A UIColor value that determines the color used for the line when error message is not `nil`
    @IBInspectable dynamic open var lineErrorColor: UIColor? {
        didSet {
            updateColors()
        }
    }

    /// A UIColor value that determines the color used for the text when error message is not `nil`
    @IBInspectable dynamic open var textErrorColor: UIColor? {
        didSet {
            updateColors()
        }
    }

    /// A UIColor value that determines the color used for the title label when error message is not `nil`
    @IBInspectable dynamic open var titleErrorColor: UIColor? {
        didSet {
            updateColors()
        }
    }

    /// A UIColor value that determines the color used for the title label and line when text field is disabled
    @IBInspectable dynamic open var disabledColor: UIColor = UIColor(white: 0.88, alpha: 1.0) {
        didSet {
            updateControl()
            updatePlaceholder()
        }
    }

    /// A UIColor value that determines the text color of the title label when editing
    @IBInspectable dynamic open var selectedTitleColor: UIColor = .blue {
        didSet {
            updateTitleColor()
        }
    }

    /// A UIColor value that determines the color of the line in a selected state
    @IBInspectable dynamic open var selectedLineColor: UIColor = .black {
        didSet {
            updateLineView()
        }
    }

    // MARK: Line height

    /// A CGFloat value that determines the height for the bottom line when the control is in the normal state
    @IBInspectable dynamic open var lineHeight: CGFloat = 0.5 {
        didSet {
            updateLineView()
            setNeedsDisplay()
        }
    }

    /// A CGFloat value that determines the height for the bottom line when the control is in a selected state
    @IBInspectable dynamic open var selectedLineHeight: CGFloat = 1.0 {
        didSet {
            updateLineView()
            setNeedsDisplay()
        }
    }

    // MARK: View components

    /// The internal `UIView` to display the line below the text input.
    open var lineView: UIView!

    /// The internal `UILabel` that displays the selected, deselected title or error message based on the current state.
    open var titleLabel: UILabel!

    // MARK: Properties

    /**
    The formatter used before displaying content in the title label. 
    This can be the `title`, `selectedTitle` or the `errorMessage`.
    The default implementation converts the text to uppercase.
    */
    open var titleFormatter: ((String) -> String) = { (text: String) -> String in
        if #available(iOS 9.0, *) {
            return text.localizedUppercase
        } else {
            return text.uppercased()
        }
    }

    /**
     Identifies whether the text object should hide the text being entered.
     */
    override open var isSecureTextEntry: Bool {
        set {
            super.isSecureTextEntry = newValue
            fixCaretPosition()
        }
        get {
            return super.isSecureTextEntry
        }
    }

    /// A String value for the error message to display.
    @IBInspectable
    open var errorMessage: String? {
        didSet {
            updateControl(true)
        }
    }

    /// The backing property for the highlighted property
    fileprivate var _highlighted: Bool = false

    /**
     A Boolean value that determines whether the receiver is highlighted.
     When changing this value, highlighting will be done with animation
     */
    override open var isHighlighted: Bool {
        get {
            return _highlighted
        }
        set {
            _highlighted = newValue
            updateTitleColor()
            updateLineView()
        }
    }

    /// A Boolean value that determines whether the textfield is being edited or is selected.
    open var editingOrSelected: Bool {
        return super.isEditing || isSelected
    }

    /// A Boolean value that determines whether the receiver has an error message.
    open var hasErrorMessage: Bool {
        return errorMessage != nil && errorMessage != ""
    }

    fileprivate var _renderingInInterfaceBuilder: Bool = false

    /// The text content of the textfield
    @IBInspectable
    override open var text: String? {
        didSet {
            updateControl(false)
        }
    }

    /**
     The String to display when the input field is empty.
     The placeholder can also appear in the title label when both `title` `selectedTitle` and are `nil`.
     */
    @IBInspectable
    override open var placeholder: String? {
        didSet {
            setNeedsDisplay()
            updatePlaceholder()
            updateTitleLabel()
        }
    }

    /// The String to display when the textfield is editing and the input is not empty.
    @IBInspectable open var selectedTitle: String? {
        didSet {
            updateControl()
        }
    }

    /// The String to display when the textfield is not editing and the input is not empty.
    @IBInspectable open var title: String? {
        didSet {
            updateControl()
        }
    }

    // Determines whether the field is selected. When selected, the title floats above the textbox.
    open override var isSelected: Bool {
        didSet {
            updateControl(true)
        }
    }

    // MARK: - Initializers

    /**
    Initializes the control
    - parameter frame the frame of the control
    */
    override public init(frame: CGRect) {
        super.init(frame: frame)
        init_FloatingSearchTextField()
    }

    /**
     Intialzies the control by deserializing it
     - parameter aDecoder the object to deserialize the control from
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        init_FloatingSearchTextField()
    }

    fileprivate final func init_FloatingSearchTextField() {
        borderStyle = .none
        createTitleLabel()
        createLineView()
        updateColors()
        addEditingChangedObserver()
        updateTextAligment()
    }

    fileprivate func addEditingChangedObserver() {
        self.addTarget(self, action: #selector(FloatingSearchTextField.editingChanged), for: .editingChanged)
    }

    /**
     Invoked when the editing state of the textfield changes. Override to respond to this change.
     */
    @objc open func editingChanged() {
        updateControl(true)
        updateTitleLabel(true)
        if !inlineMode && tableView == nil {
                   buildSearchTableView()
               }
               
               interactedWith = true
               
               // Detect pauses while typing
               timer?.invalidate()
               timer = Timer.scheduledTimer(timeInterval: typingStoppedDelay, target: self, selector: #selector(FloatingSearchTextField.typingDidStop), userInfo: self, repeats: false)
               
               if text!.isEmpty {
                   clearResults()
                   tableView?.reloadData()
                   if startVisible || startVisibleWithoutInteraction {
                       filter(forceShowAll: true)
                   }
                   self.placeholderLabel?.text = ""
               } else {
                   filter(forceShowAll: forceNoFiltering)
                   prepareDrawTableResult()
               }
               
               buildPlaceholderLabel()
    }

    // MARK: create components

    fileprivate func createTitleLabel() {
        let titleLabel = UILabel()
        titleLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        titleLabel.font = titleFont
        titleLabel.alpha = 0.0
        titleLabel.textColor = titleColor

        addSubview(titleLabel)
        self.titleLabel = titleLabel
    }

    fileprivate func createLineView() {

        if lineView == nil {
            let lineView = UIView()
            lineView.isUserInteractionEnabled = false
            self.lineView = lineView
            configureDefaultLineHeight()
        }

        lineView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        addSubview(lineView)
    }

    fileprivate func configureDefaultLineHeight() {
        let onePixel: CGFloat = 1.0 / UIScreen.main.scale
        lineHeight = 2.0 * onePixel
        selectedLineHeight = 2.0 * self.lineHeight
    }

    // MARK: Responder handling

    /**
     Attempt the control to become the first responder
     - returns: True when successfull becoming the first responder
    */
    @discardableResult
    override open func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        updateControl(true)
        return result
    }

    /**
     Attempt the control to resign being the first responder
     - returns: True when successfull resigning being the first responder
     */
    @discardableResult
    override open func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        updateControl(true)
        return result
    }

    /// update colors when is enabled changed
    override open var isEnabled: Bool {
        didSet {
            updateControl()
            updatePlaceholder()
        }
    }

    // MARK: - View updates

    fileprivate func updateControl(_ animated: Bool = false) {
        updateColors()
        updateLineView()
        updateTitleLabel(animated)
    }

    fileprivate func updateLineView() {
        guard let lineView = lineView else {
            return
        }

        lineView.frame = lineViewRectForBounds(bounds, editing: editingOrSelected)
        updateLineColor()
    }

    // MARK: - Color updates

    /// Update the colors for the control. Override to customize colors.
    open func updateColors() {
        updateLineColor()
        updateTitleColor()
        updateTextColor()
    }

    fileprivate func updateLineColor() {
        guard let lineView = lineView else {
            return
        }

        if !isEnabled {
            lineView.backgroundColor = disabledColor
        } else if hasErrorMessage {
            lineView.backgroundColor = lineErrorColor ?? errorColor
        } else {
            lineView.backgroundColor = editingOrSelected ? selectedLineColor : lineColor
        }
    }

    fileprivate func updateTitleColor() {
        guard let titleLabel = titleLabel else {
            return
        }

        if !isEnabled {
            titleLabel.textColor = disabledColor
        } else if hasErrorMessage {
            titleLabel.textColor = titleErrorColor ?? errorColor
        } else {
            if editingOrSelected || isHighlighted {
                titleLabel.textColor = selectedTitleColor
            } else {
                titleLabel.textColor = titleColor
            }
        }
    }

    fileprivate func updateTextColor() {
        if !isEnabled {
            super.textColor = disabledColor
        } else if hasErrorMessage {
            super.textColor = textErrorColor ?? errorColor
        } else {
            super.textColor = cachedTextColor
        }
    }

    // MARK: - Title handling
  override open var intrinsicContentSize: CGSize {
      return CGSize(width: bounds.size.width, height: titleHeight() + textHeight())
  }

  // MARK: - Helpers

  fileprivate func titleOrPlaceholder() -> String? {
      guard let title = title ?? placeholder else {
          return nil
      }
      return titleFormatter(title)
  }

  fileprivate func selectedTitleOrTitlePlaceholder() -> String? {
      guard let title = selectedTitle ?? title ?? placeholder else {
          return nil
      }
      return titleFormatter(title)
  }
    fileprivate func updateTitleLabel(_ animated: Bool = false) {
        guard let titleLabel = titleLabel else {
            return
        }

        var titleText: String?
        if hasErrorMessage {
            titleText = titleFormatter(errorMessage!)
        } else {
            if editingOrSelected {
                titleText = selectedTitleOrTitlePlaceholder()
                if titleText == nil {
                    titleText = titleOrPlaceholder()
                }
            } else {
                titleText = titleOrPlaceholder()
            }
        }
        titleLabel.text = titleText
        titleLabel.font = titleFont

        updateTitleVisibility(animated)
    }

    fileprivate var _titleVisible: Bool = false

    /*
    *   Set this value to make the title visible
    */
    open func setTitleVisible(
        _ titleVisible: Bool,
        animated: Bool = false,
        animationCompletion: ((_ completed: Bool) -> Void)? = nil
    ) {
        if _titleVisible == titleVisible {
            return
        }
        _titleVisible = titleVisible
        updateTitleColor()
        updateTitleVisibility(animated, completion: animationCompletion)
    }

    /**
     Returns whether the title is being displayed on the control.
     - returns: True if the title is displayed on the control, false otherwise.
     */
    open func isTitleVisible() -> Bool {
        return hasText || hasErrorMessage || _titleVisible
    }

    fileprivate func updateTitleVisibility(_ animated: Bool = false, completion: ((_ completed: Bool) -> Void)? = nil) {
        let alpha: CGFloat = isTitleVisible() ? 1.0 : 0.0
        let frame: CGRect = titleLabelRectForBounds(bounds, editing: isTitleVisible())
        let updateBlock = { () -> Void in
            self.titleLabel.alpha = alpha
            self.titleLabel.frame = frame
        }
        if animated {
            #if swift(>=4.2)
                let animationOptions: UIView.AnimationOptions = .curveEaseOut
            #else
                let animationOptions: UIViewAnimationOptions = .curveEaseOut
            #endif
            let duration = isTitleVisible() ? titleFadeInDuration : titleFadeOutDuration
            UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: { () -> Void in
                updateBlock()
                }, completion: completion)
        } else {
            updateBlock()
            completion?(true)
        }
    }

    // MARK: - UITextField text/placeholder positioning overrides

    /**
    Calculate the rectangle for the textfield when it is not being edited
    - parameter bounds: The current bounds of the field
    - returns: The rectangle that the textfield should render in
    */
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.textRect(forBounds: bounds)
        let titleHeight = self.titleHeight()

        let rect = CGRect(
            x: superRect.origin.x,
            y: titleHeight,
            width: superRect.size.width,
            height: superRect.size.height - titleHeight - selectedLineHeight
        )
        return rect
    }

    /**
     Calculate the rectangle for the textfield when it is being edited
     - parameter bounds: The current bounds of the field
     - returns: The rectangle that the textfield should render in
     */
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.editingRect(forBounds: bounds)
        let titleHeight = self.titleHeight()

        let rect = CGRect(
            x: superRect.origin.x,
            y: titleHeight,
            width: superRect.size.width,
            height: superRect.size.height - titleHeight - selectedLineHeight
        )
        return rect
    }

    /**
     Calculate the rectangle for the placeholder
     - parameter bounds: The current bounds of the placeholder
     - returns: The rectangle that the placeholder should render in
     */
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let rect = CGRect(
            x: 0,
            y: titleHeight(),
            width: bounds.size.width,
            height: bounds.size.height - titleHeight() - selectedLineHeight
        )
        return rect
    }

    // MARK: - Positioning Overrides

    /**
    Calculate the bounds for the title label. Override to create a custom size title field.
    - parameter bounds: The current bounds of the title
    - parameter editing: True if the control is selected or highlighted
    - returns: The rectangle that the title label should render in
    */
    open func titleLabelRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
        if editing {
            return CGRect(x: 0, y: 0, width: bounds.size.width, height: titleHeight())
        }
        return CGRect(x: 0, y: titleHeight(), width: bounds.size.width, height: titleHeight())
    }

    /**
     Calculate the bounds for the bottom line of the control. 
     Override to create a custom size bottom line in the textbox.
     - parameter bounds: The current bounds of the line
     - parameter editing: True if the control is selected or highlighted
     - returns: The rectangle that the line bar should render in
     */
    open func lineViewRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
        let height = editing ? selectedLineHeight : lineHeight
        return CGRect(x: 0, y: bounds.size.height - height, width: bounds.size.width, height: height)
    }

    /**
     Calculate the height of the title label.
     -returns: the calculated height of the title label. Override to size the title with a different height
     */
    open func titleHeight() -> CGFloat {
        if let titleLabel = titleLabel,
            let font = titleLabel.font {
            return font.lineHeight
        }
        return 15.0
    }

    /**
     Calcualte the height of the textfield.
     -returns: the calculated height of the textfield. Override to size the textfield with a different height
     */
    open func textHeight() -> CGFloat {
        guard let font = self.font else {
            return 0.0
        }

        return font.lineHeight + 7.0
    }

    // MARK: - Layout

    /// Invoked when the interface builder renders the control
    override open func prepareForInterfaceBuilder() {
        if #available(iOS 8.0, *) {
            super.prepareForInterfaceBuilder()
        }

        borderStyle = .none

        isSelected = true
        _renderingInInterfaceBuilder = true
        updateControl(false)
        invalidateIntrinsicContentSize()
    }

    /// Invoked by layoutIfNeeded automatically
    override open func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.frame = titleLabelRectForBounds(bounds, editing: isTitleVisible() || _renderingInInterfaceBuilder)
        lineView.frame = lineViewRectForBounds(bounds, editing: editingOrSelected || _renderingInInterfaceBuilder)
        super.layoutSubviews()
        
        if inlineMode {
            buildPlaceholderLabel()
        } else {
            buildSearchTableView()
        }
        
        // Create the loading indicator
        indicator.hidesWhenStopped = true
        self.rightView = indicator
    }

    /**
     Calculate the content size for auto layout

     - returns: the content size to be used for auto layout
     */
    
    
    //search
     override open func willMove(toSuperview newSuperview: UIView?) {
            super.willMove(toSuperview: newSuperview)
            
    //        self.addTarget(self, action: #selector(SearchTextField.textFieldDidChange), for: .editingChanged)
            self.addTarget(self, action: #selector(FloatingSearchTextField.textFieldDidBeginEditing), for: .editingDidBegin)
            self.addTarget(self, action: #selector(FloatingSearchTextField.textFieldDidEndEditing), for: .editingDidEnd)
            self.addTarget(self, action: #selector(FloatingSearchTextField.textFieldDidEndEditingOnExit), for: .editingDidEndOnExit)
            
            NotificationCenter.default.addObserver(self, selector: #selector(FloatingSearchTextField.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(FloatingSearchTextField.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(FloatingSearchTextField.keyboardDidChangeFrame(_:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        }
        
        override open func rightViewRect(forBounds bounds: CGRect) -> CGRect {
            var rightFrame = super.rightViewRect(forBounds: bounds)
            rightFrame.origin.x -= 5
            return rightFrame
        }
        
        // Create the filter table and shadow view
        fileprivate func buildSearchTableView() {
            guard let tableView = tableView, let shadowView = shadowView else {
                self.tableView = UITableView(frame: CGRect.zero)
                self.shadowView = UIView(frame: CGRect.zero)
                buildSearchTableView()
                return
            }
            
            tableView.layer.masksToBounds = true
            tableView.layer.borderWidth = theme.borderWidth > 0 ? theme.borderWidth : 0.5
            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorInset = UIEdgeInsets.zero
            tableView.tableHeaderView = resultsListHeader
            if forceRightToLeft {
                tableView.semanticContentAttribute = .forceRightToLeft
            }
            
            shadowView.backgroundColor = UIColor.lightText
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOffset = CGSize.zero
            shadowView.layer.shadowOpacity = 1
            
            self.window?.addSubview(tableView)
            
            redrawSearchTableView()
        }
        
        fileprivate func buildPlaceholderLabel() {
            var newRect = self.placeholderRect(forBounds: self.bounds)
            var caretRect = self.caretRect(for: self.beginningOfDocument)
            let textRect = self.textRect(forBounds: self.bounds)
            
            if let range = textRange(from: beginningOfDocument, to: endOfDocument) {
                caretRect = self.firstRect(for: range)
            }
            
            newRect.origin.x = caretRect.origin.x + caretRect.size.width + textRect.origin.x
            newRect.size.width = newRect.size.width - newRect.origin.x
            
            if let placeholderLabel = placeholderLabel {
                placeholderLabel.font = self.font
                placeholderLabel.frame = newRect
            } else {
                placeholderLabel = UILabel(frame: newRect)
                placeholderLabel?.font = self.font
                placeholderLabel?.backgroundColor = UIColor.clear
                placeholderLabel?.lineBreakMode = .byClipping
                
                if let placeholderColor = self.attributedPlaceholder?.attribute(NSAttributedString.Key.foregroundColor, at: 0, effectiveRange: nil) as? UIColor {
                    placeholderLabel?.textColor = placeholderColor
                } else {
                    placeholderLabel?.textColor = UIColor ( red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0 )
                }
                
                self.addSubview(placeholderLabel!)
            }
        }
        
        // Re-set frames and theme colors
        fileprivate func redrawSearchTableView() {
            if inlineMode {
                tableView?.isHidden = true
                return
            }
            
            if let tableView = tableView {
                guard let frame = self.superview?.convert(self.frame, to: nil) else { return }
                
                //TableViews use estimated cell heights to calculate content size until they
                //  are on-screen. We must set this to the theme cell height to avoid getting an
                //  incorrect contentSize when we have specified non-standard fonts and/or
                //  cellHeights in the theme. We do it here to ensure updates to these settings
                //  are recognized if changed after the tableView is created
                tableView.estimatedRowHeight = theme.cellHeight
                if self.direction == .down {
                    
                    var tableHeight: CGFloat = 0
                    if keyboardIsShowing, let keyboardHeight = keyboardFrame?.size.height {
                        tableHeight = min((tableView.contentSize.height), (UIScreen.main.bounds.size.height - frame.origin.y - frame.height - keyboardHeight))
                    } else {
                        tableHeight = min((tableView.contentSize.height), (UIScreen.main.bounds.size.height - frame.origin.y - frame.height))
                    }
                    
                    if maxResultsListHeight > 0 {
                        tableHeight = min(tableHeight, CGFloat(maxResultsListHeight))
                    }
                    
                    // Set a bottom margin of 10p
                    if tableHeight < tableView.contentSize.height {
                        tableHeight -= tableBottomMargin
                    }
                    
                    var tableViewFrame = CGRect(x: 0, y: 0, width: frame.size.width - 4, height: tableHeight)
                    tableViewFrame.origin = self.convert(tableViewFrame.origin, to: nil)
                    tableViewFrame.origin.x += 2 + tableXOffset
                    tableViewFrame.origin.y += frame.size.height + 2 + tableYOffset
                    self.tableView?.frame.origin = tableViewFrame.origin // Avoid animating from (0, 0) when displaying at launch
                    UIView.animate(withDuration: 0.2, animations: { [weak self] in
                        self?.tableView?.frame = tableViewFrame
                    })
                    
                    var shadowFrame = CGRect(x: 0, y: 0, width: frame.size.width - 6, height: 1)
                    shadowFrame.origin = self.convert(shadowFrame.origin, to: nil)
                    shadowFrame.origin.x += 3
                    shadowFrame.origin.y = tableView.frame.origin.y
                    shadowView!.frame = shadowFrame
                } else {
                    let tableHeight = min((tableView.contentSize.height), (UIScreen.main.bounds.size.height - frame.origin.y - theme.cellHeight))
                    UIView.animate(withDuration: 0.2, animations: { [weak self] in
                        self?.tableView?.frame = CGRect(x: frame.origin.x + 2, y: (frame.origin.y - tableHeight), width: frame.size.width - 4, height: tableHeight)
                        self?.shadowView?.frame = CGRect(x: frame.origin.x + 3, y: (frame.origin.y + 3), width: frame.size.width - 6, height: 1)
                    })
                }
                
                superview?.bringSubviewToFront(tableView)
                superview?.bringSubviewToFront(shadowView!)
                
                if self.isFirstResponder {
                    superview?.bringSubviewToFront(self)
                }
                
                tableView.layer.borderColor = theme.borderColor.cgColor
                tableView.layer.cornerRadius = tableCornerRadius
                tableView.separatorColor = theme.separatorColor
                tableView.backgroundColor = theme.bgColor
                
                tableView.reloadData()
            }
        }
        
        // Handle keyboard events
        @objc open func keyboardWillShow(_ notification: Notification) {
            if !keyboardIsShowing && isEditing {
                keyboardIsShowing = true
                keyboardFrame = ((notification as NSNotification).userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
                interactedWith = true
                prepareDrawTableResult()
            }
        }
        
        @objc open func keyboardWillHide(_ notification: Notification) {
            if keyboardIsShowing {
                keyboardIsShowing = false
                direction = .down
                redrawSearchTableView()
            }
        }
        
        @objc open func keyboardDidChangeFrame(_ notification: Notification) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.keyboardFrame = ((notification as NSNotification).userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
                self?.prepareDrawTableResult()
            }
        }
        
        @objc open func typingDidStop() {
            self.userStoppedTypingHandler?()
        }
        
        // Handle text field changes
        @objc open func textFieldDidChange() {
            if !inlineMode && tableView == nil {
                buildSearchTableView()
            }
            
            interactedWith = true
            
            // Detect pauses while typing
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: typingStoppedDelay, target: self, selector: #selector(FloatingSearchTextField.typingDidStop), userInfo: self, repeats: false)
            
            if text!.isEmpty {
                clearResults()
                tableView?.reloadData()
                if startVisible || startVisibleWithoutInteraction {
                    filter(forceShowAll: true)
                }
                self.placeholderLabel?.text = ""
            } else {
                filter(forceShowAll: forceNoFiltering)
                prepareDrawTableResult()
            }
            
            buildPlaceholderLabel()
        }
        
        @objc open func textFieldDidBeginEditing() {
            if (startVisible || startVisibleWithoutInteraction) && text!.isEmpty {
                clearResults()
                filter(forceShowAll: true)
            }
            placeholderLabel?.attributedText = nil
        }
        
        @objc open func textFieldDidEndEditing() {
            clearResults()
            tableView?.reloadData()
            placeholderLabel?.attributedText = nil
        }
        
        @objc open func textFieldDidEndEditingOnExit() {
            if let firstElement = filteredResults.first {
                if let itemSelectionHandler = self.itemSelectionHandler {
                    itemSelectionHandler(filteredResults, 0)
                }
                else {
                    if inlineMode, let filterAfter = startFilteringAfter {
                        let stringElements = self.text?.components(separatedBy: filterAfter)
                        
                        self.text = stringElements!.first! + filterAfter + firstElement.title
                    } else {
                        self.text = firstElement.title
                    }
                }
            }
        }
        
        open func hideResultsList() {
            if let tableFrame:CGRect = tableView?.frame {
                let newFrame = CGRect(x: tableFrame.origin.x, y: tableFrame.origin.y, width: tableFrame.size.width, height: 0.0)
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    self?.tableView?.frame = newFrame
                })
                
            }
        }
        
        fileprivate func filter(forceShowAll addAll: Bool) {
            clearResults()
            
            if text!.count < minCharactersNumberToStartFiltering {
                return
            }
            
            for i in 0 ..< filterDataSource.count {
                
                let item = filterDataSource[i]
                
                if !inlineMode {
                    // Find text in title and subtitle
                    let titleFilterRange = (item.title as NSString).range(of: text!, options: comparisonOptions)
                    let subtitleFilterRange = item.subtitle != nil ? (item.subtitle! as NSString).range(of: text!, options: comparisonOptions) : NSMakeRange(NSNotFound, 0)
                    
                    if titleFilterRange.location != NSNotFound || subtitleFilterRange.location != NSNotFound || addAll {
                        item.attributedTitle = NSMutableAttributedString(string: item.title)
                        item.attributedSubtitle = NSMutableAttributedString(string: (item.subtitle != nil ? item.subtitle! : ""))
                        
                        item.attributedTitle!.setAttributes(highlightAttributes, range: titleFilterRange)
                        
                        if subtitleFilterRange.location != NSNotFound {
                            item.attributedSubtitle!.setAttributes(highlightAttributesForSubtitle(), range: subtitleFilterRange)
                        }
                        
                        filteredResults.append(item)
                    }
                } else {
                    var textToFilter = text!.lowercased()
                    
                    if inlineMode, let filterAfter = startFilteringAfter {
                        if let suffixToFilter = textToFilter.components(separatedBy: filterAfter).last, (suffixToFilter != "" || startSuggestingImmediately == true), textToFilter != suffixToFilter {
                            textToFilter = suffixToFilter
                        } else {
                            placeholderLabel?.text = ""
                            return
                        }
                    }
                    
                    if item.title.lowercased().hasPrefix(textToFilter) {
                        let indexFrom = textToFilter.index(textToFilter.startIndex, offsetBy: textToFilter.count)
                        let itemSuffix = item.title[indexFrom...]
                        
                        item.attributedTitle = NSMutableAttributedString(string: String(itemSuffix))
                        filteredResults.append(item)
                    }
                }
            }
            
            tableView?.reloadData()
            
            if inlineMode {
                handleInlineFiltering()
            }
        }
        
        // Clean filtered results
         func clearResults() {
            filteredResults.removeAll()
            tableView?.removeFromSuperview()
        }
        
        // Look for Font attribute, and if it exists, adapt to the subtitle font size
        fileprivate func highlightAttributesForSubtitle() -> [NSAttributedString.Key: AnyObject] {
            var highlightAttributesForSubtitle = [NSAttributedString.Key: AnyObject]()
            
            for attr in highlightAttributes {
                if attr.0 == NSAttributedString.Key.font {
                    let fontName = (attr.1 as! UIFont).fontName
                    let pointSize = (attr.1 as! UIFont).pointSize * fontConversionRate
                    highlightAttributesForSubtitle[attr.0] = UIFont(name: fontName, size: pointSize)
                } else {
                    highlightAttributesForSubtitle[attr.0] = attr.1
                }
            }
            
            return highlightAttributesForSubtitle
        }
        
        // Handle inline behaviour
        func handleInlineFiltering() {
            if let text = self.text {
                if text == "" {
                    self.placeholderLabel?.attributedText = nil
                } else {
                    if let firstResult = filteredResults.first {
                        self.placeholderLabel?.attributedText = firstResult.attributedTitle
                    } else {
                        self.placeholderLabel?.attributedText = nil
                    }
                }
            }
        }
        
        // MARK: - Prepare for draw table result
        
        fileprivate func prepareDrawTableResult() {
            guard let frame = self.superview?.convert(self.frame, to: UIApplication.shared.keyWindow) else { return }
            if let keyboardFrame = keyboardFrame {
                var newFrame = frame
                newFrame.size.height += theme.cellHeight
                
                if keyboardFrame.intersects(newFrame) {
                    direction = .up
                } else {
                    direction = .down
                }
                
                redrawSearchTableView()
            } else {
                if self.center.y + theme.cellHeight > UIApplication.shared.keyWindow!.frame.size.height {
                    direction = .up
                } else {
                    direction = .down
                }
            }
        }
    }

    extension FloatingSearchTextField: UITableViewDelegate, UITableViewDataSource {
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            tableView.isHidden = !interactedWith || (filteredResults.count == 0)
            shadowView?.isHidden = !interactedWith || (filteredResults.count == 0)
            
            if maxNumberOfResults > 0 {
                return min(filteredResults.count, maxNumberOfResults)
            } else {
                return filteredResults.count
            }
        }
        
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var cell = tableView.dequeueReusableCell(withIdentifier: FloatingSearchTextField.cellIdentifier)
            
            if cell == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: FloatingSearchTextField.cellIdentifier)
            }
            
            cell!.backgroundColor = UIColor.clear
            cell!.layoutMargins = UIEdgeInsets.zero
            cell!.preservesSuperviewLayoutMargins = false
            cell!.textLabel?.font = theme.font
            cell!.detailTextLabel?.font = UIFont(name: theme.font.fontName, size: theme.font.pointSize * fontConversionRate)
            cell!.textLabel?.textColor = theme.fontColor
            cell!.detailTextLabel?.textColor = theme.subtitleFontColor
            
            cell!.textLabel?.text = filteredResults[(indexPath as NSIndexPath).row].title
            cell!.detailTextLabel?.text = filteredResults[(indexPath as NSIndexPath).row].subtitle
            cell!.textLabel?.attributedText = filteredResults[(indexPath as NSIndexPath).row].attributedTitle
            cell!.detailTextLabel?.attributedText = filteredResults[(indexPath as NSIndexPath).row].attributedSubtitle
            
            cell!.imageView?.image = filteredResults[(indexPath as NSIndexPath).row].image
            
            cell!.selectionStyle = .none
            
            return cell!
        }
        
        public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return theme.cellHeight
        }
        
        public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if itemSelectionHandler == nil {
                self.text = filteredResults[(indexPath as NSIndexPath).row].title
            } else {
                let index = indexPath.row
                itemSelectionHandler!(filteredResults, index)
            }
            
            clearResults()
        }
    }

    ////////////////////////////////////////////////////////////////////////
    // Search Text Field Theme


    ////////////////////////////////////////////////////////////////////////
    // Filter Item
 // swiftlint:disable:this file_length

open class SearchTextFieldItem {
    // Private vars
    fileprivate var attributedTitle: NSMutableAttributedString?
    fileprivate var attributedSubtitle: NSMutableAttributedString?
    
    // Public interface
    public var title: String
    public var subtitle: String?
    public var image: UIImage?
    
    public init(title: String, subtitle: String?, image: UIImage?) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
    }
    
    public init(title: String, subtitle: String?) {
        self.title = title
        self.subtitle = subtitle
    }
    
    public init(title: String) {
        self.title = title
    }
}
public struct FloatingSearchTextFieldTheme {
    public var cellHeight: CGFloat
    public var bgColor: UIColor
    public var borderColor: UIColor
    public var borderWidth : CGFloat = 0
    public var separatorColor: UIColor
    public var font: UIFont
    public var fontColor: UIColor
    public var subtitleFontColor: UIColor
    public var placeholderColor: UIColor?

    init(cellHeight: CGFloat, bgColor:UIColor, borderColor: UIColor, separatorColor: UIColor, font: UIFont, fontColor: UIColor, subtitleFontColor: UIColor? = nil) {
        self.cellHeight = cellHeight
        self.borderColor = borderColor
        self.separatorColor = separatorColor
        self.bgColor = bgColor
        self.font = font
        self.fontColor = fontColor
        self.subtitleFontColor = subtitleFontColor ?? fontColor
    }

    public static func lightTheme() -> FloatingSearchTextFieldTheme {
        return FloatingSearchTextFieldTheme(cellHeight: 30, bgColor: UIColor (red: 1, green: 1, blue: 1, alpha: 0.6), borderColor: UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0), separatorColor: UIColor.clear, font: UIFont.systemFont(ofSize: 10), fontColor: UIColor.black)
    }

    public static func darkTheme() -> FloatingSearchTextFieldTheme {
        return FloatingSearchTextFieldTheme(cellHeight: 30, bgColor: UIColor (red: 0.8, green: 0.8, blue: 0.8, alpha: 0.6), borderColor: UIColor (red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0), separatorColor: UIColor.clear, font: UIFont.systemFont(ofSize: 10), fontColor: UIColor.white)
    }
}

public typealias SearchTextFieldItemHandler = (_ filteredResults: [SearchTextFieldItem], _ index: Int) -> Void

////////////////////////////////////////////////////////////////////////
// Suggestions List Direction

enum Direction {
    case down
    case up
}

