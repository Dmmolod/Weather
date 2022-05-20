import UIKit

class FavouritesView: UIView {

    private let screenTitle: UILabel
    private let searchField: UISearchTextField
    private let resultTable: ResultTable
    private let cancelButton: UIButton
    private let shadowEffectView: UIView
    private let container = UIView()
    //MARK: Animate constraints
    private var cancelButtonHideConstraint = NSLayoutConstraint()
    private var screenTitleHideConstraint = NSLayoutConstraint()
    private var tableBottomAnchorToBottomAnchor = NSLayoutConstraint()
    private var tableBottomAnchorToKeyboardTopAnchor = NSLayoutConstraint()

    init(screenTitle: UILabel,
         searchField: UISearchTextField,
         resultTable: ResultTable,
         cancelButton: UIButton,
         shadowEffectView: UIView)
    {
        self.screenTitle = screenTitle
        self.searchField = searchField
        self.resultTable = resultTable
        self.cancelButton = cancelButton
        self.shadowEffectView = shadowEffectView
        
        super.init(frame: .zero)
        setupUI()
        setupElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateElementsWith(searchState state: Bool) {
        cancelButton.isHidden = !state
        cancelButtonHideConstraint.isActive = !state
        screenTitleHideConstraint.isActive = state
        
        if state {
            tableBottomAnchorToBottomAnchor.isActive = false
            tableBottomAnchorToKeyboardTopAnchor.isActive = true
        } else {
            tableBottomAnchorToKeyboardTopAnchor.isActive = false
            tableBottomAnchorToBottomAnchor.isActive = true
        }
        
        
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.layoutIfNeeded()
        }
    }
   
    private func setupElements() {
        backgroundColor = resultTable.backgroundColor
        
        screenTitle.font = .systemFont(ofSize: 30, weight: .bold)
        screenTitle.text = "Weather".localized
        
        searchField.placeholder = "City name".localized
        searchField.returnKeyType = .search
        searchField.enablesReturnKeyAutomatically = true
        searchField.autocorrectionType = .no
        
        cancelButton.isHidden = true
        cancelButton.configuration = .plain()
        cancelButton.tintColor = .systemGray3
        cancelButton.configuration?.title = "Сancel".localized
        
        shadowEffectView.backgroundColor = .systemBackground
        shadowEffectView.isHidden = true
        shadowEffectView.alpha = 0.6
    }
    
    private func setupUI() {
        container.backgroundColor = .clear
        
        [screenTitle, cancelButton, searchField].forEach({ container.addSubview($0) })
        [resultTable, shadowEffectView, container].forEach { addSubview($0) }
        
        container.anchor(top: safeAreaLayoutGuide.topAnchor,
                         leading: leadingAnchor,
                         trailing: trailingAnchor)
        
        screenTitle.anchor(top: container.topAnchor,
                           leading: container.leadingAnchor,
                           paddingLeading: Constans.leftInset)
        
        screenTitleHideConstraint = screenTitle.heightAnchor.constraint(equalToConstant: 0)
        
        searchField.anchor(top: screenTitle.bottomAnchor,
                           bottom: container.bottomAnchor,
                           leading: screenTitle.leadingAnchor,
                           trailing: cancelButton.leadingAnchor,
                           paddingTop: Constans.topInset)
        
        cancelButton.anchor(top: searchField.topAnchor,
                            bottom: searchField.bottomAnchor,
                            trailing: container.trailingAnchor,
                            paddingTrailing: Constans.rightInset)
        
        cancelButtonHideConstraint = cancelButton.widthAnchor.constraint(equalToConstant: 0)
        cancelButtonHideConstraint.isActive = true
        
        
        resultTable.anchor(top: container.bottomAnchor,
                           leading: container.leadingAnchor,
                           trailing: container.trailingAnchor,
                           paddingTop: 5,
                           paddingLeading: Constans.leftInset,
                           paddingTrailing: Constans.rightInset)
        
        tableBottomAnchorToBottomAnchor = resultTable.bottomAnchor.constraint(equalTo: bottomAnchor)
        tableBottomAnchorToKeyboardTopAnchor = resultTable.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor)
        tableBottomAnchorToBottomAnchor.isActive = true
        
        shadowEffectView.anchor(top: topAnchor,
                                bottom: bottomAnchor,
                                leading: leadingAnchor,
                                trailing: trailingAnchor)
    }
}
