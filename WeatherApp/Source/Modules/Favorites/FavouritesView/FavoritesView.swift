import UIKit

final class FavoritesView: UIView {
    
    //MARK: - Private Properties
    private let screenTitle = UILabel()
    private let searchField = UISearchTextField()
    private let resultTable = ResultTable()
    private let cancelButton = UIButton()
    private let shadowEffectView = UIView()
    private let container = UIView()
    
    private var favoritesSearchDelegate: FavoritesSearchDelegate?
    private var cancelDidTapAction: (() -> ())?
    
    //MARK: - Animatable constraints
    private var cancelButtonHideConstraint = NSLayoutConstraint()
    private var screenTitleHideConstraint = NSLayoutConstraint()
    private var tableBottomConstraint = NSLayoutConstraint()
    
    //MARK: - Initializers
    init() {
        super.init(frame: .zero)

        cancelButton.addTarget(
            self,
            action: #selector(cancelButtonDidTap),
            for: .touchUpInside
        )

        setupUI()
        setupElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - API
    func subscribeTable(with model: ResultTableViewModelProtocol) {
        resultTable.subscribe(with: model)
    }
    
    func setupCancelButton(action: @escaping () -> ()) {
        cancelDidTapAction = action
    }
    
    func setupFavoritesSearchDelegate(_ setup: (FavoritesSearchDelegate) -> Void) {
        let delegate = FavoritesSearchDelegate()
        setup(delegate)
        favoritesSearchDelegate = delegate
        searchField.delegate = delegate
    }
    
    func setShadowEffect(isHidden: Bool) {
        let fadeAnimation = { self.shadowEffectView.isHidden = isHidden }
        UIView.animate(withDuration: 0.3, animations: fadeAnimation)
    }
    
    func setSearchTextFieldText(_ text: String?) {
        searchField.text = text
    }
        
    func cellFor(_ indexPath: IndexPath) -> UITableViewCell? {
        return resultTable.cellForRow(at: indexPath)
    }
    
    func setSearch(isActive: Bool) {
        cancelButton.isHidden = !isActive
        
        cancelButtonHideConstraint.isActive = !isActive
        screenTitleHideConstraint.isActive = isActive
        
        tableBottomConstraint.constant = isActive ? 0 : safeAreaInsets.bottom
        
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.layoutIfNeeded()
        }
    }
    
    //MARK: - Private Methods
    @objc
    private func cancelButtonDidTap() {
        cancelDidTapAction?()
    }
    
    //MARK: - Private Layout
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
        
        container.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor
        )
        
        screenTitle.anchor(
            top: container.topAnchor,
            leading: container.leadingAnchor,
            paddingLeading: Constans.leftInset
        )
        
        screenTitleHideConstraint = screenTitle.heightAnchor.constraint(equalToConstant: 0)
        
        searchField.anchor(
            top: screenTitle.bottomAnchor,
            bottom: container.bottomAnchor,
            leading: screenTitle.leadingAnchor,
            trailing: cancelButton.leadingAnchor,
            paddingTop: Constans.topInset
        )
        
        cancelButton.anchor(
            top: searchField.topAnchor,
            bottom: searchField.bottomAnchor,
            trailing: container.trailingAnchor,
            paddingTrailing: Constans.rightInset
        )
        
        cancelButtonHideConstraint = cancelButton.widthAnchor.constraint(equalToConstant: 0)
        cancelButtonHideConstraint.isActive = true
        
        
        resultTable.anchor(
            top: container.bottomAnchor,
            leading: container.leadingAnchor,
            trailing: container.trailingAnchor,
            paddingTop: 5
        )
        
        tableBottomConstraint = resultTable.bottomAnchor.constraint(
            equalTo: keyboardLayoutGuide.topAnchor,
            constant: 34
        )
        tableBottomConstraint.isActive = true
        
        shadowEffectView.anchor(
            top: topAnchor,
            bottom: bottomAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor
        )
    }
}
