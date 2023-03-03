import UIKit



final class FavoriteCityCell: UITableViewCell {
    private let container = UIView()
    private let headerLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let currentTemperatureLabel = UILabel()
    private let infoTemperatureLabel = UILabel()
    private let icon = UIImageView()
    private let gradient = CAGradientLayer()
    private let loadSpinner = UIActivityIndicatorView(style: .medium)
    
    private var containerTopConstraint: NSLayoutConstraint?
    private var containerBottomConstraint: NSLayoutConstraint?
    private var containerLeadingConstraint: NSLayoutConstraint?
    private var containerTrailingConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupElements()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        loadSpinner.startAnimating()
        loadSpinner.isHidden = false
    }
    
    func configure(with model: FavoriteCellViewModel) {
        headerLabel.text = model.headerTitle
        subtitleLabel.text = model.subtitle
        descriptionLabel.text = model.descriptionTitle
        currentTemperatureLabel.text = model.currentTemperatureTitle
        infoTemperatureLabel.text = model.infoTemperatureTitle
        gradient.colors = model.gradientColors
        
        model.icon.bind { [weak self] icon in
            self?.loadSpinner.stopAnimating()
            self?.loadSpinner.isHidden = true
            self?.icon.image = icon
        }
    }
}

extension FavoriteCityCell: ZoomingAnimateLifeCycle {
    func preTransitionStateWillSet(for operation: UINavigationController.Operation) {
        frame = frame.offsetBy(
            dx: Constans.rightInset,
            dy: 0
        )
        
        frame.size = CGSize(
            width: frame.width - Constans.rightInset - Constans.leftInset,
            height: frame.height
        )
        setContainerConstraints(equalTo: self, isDefault: false)
        layoutIfNeeded()
    }
    
    func animationComplete(for operation: UINavigationController.Operation) {
        if operation  == .pop {
            frame = frame.offsetBy(
                dx: -Constans.rightInset,
                dy: 0
            )
            
            frame.size = CGSize(
                width: frame.width + Constans.rightInset + Constans.leftInset,
                height: frame.height
            )
        }
        setContainerConstraints(equalTo: contentView, isDefault: true)
        layoutIfNeeded()
    }
}

//MARK: - Private layout
private extension FavoriteCityCell {
    func setupUI() {
        layer.cornerRadius = 30
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(container)
        
        [
            headerLabel,
            subtitleLabel,
            descriptionLabel,
            currentTemperatureLabel,
            infoTemperatureLabel,
            icon,
            loadSpinner
        ].forEach { subview in container.addSubview(subview) }
    }
    
    func setupConstraints() {
        container.translatesAutoresizingMaskIntoConstraints = false
        setContainerConstraints(equalTo: contentView, isDefault: true)
        
        setupHeaderLabelConstraints()
        setupSubtitleLabelConstraints()
        setupDescriptionLabelConstraints()
        setupCurrentTemperatureLabelConstraints()
        setupInfoTemperatureLabelConstraints()
        setupIconConstraints()
    }
    
    func setupElements() {
        container.layer.insertSublayer(gradient, at: 0)
        container.layer.cornerRadius = layer.cornerRadius
        container.clipsToBounds = true
        
        gradient.startPoint = GradientPoint.topLeading.cgPoint
        gradient.endPoint = GradientPoint.trailing.cgPoint
        gradient.frame = UIScreen.main.bounds
        
        [
            headerLabel,
            subtitleLabel,
            descriptionLabel,
            currentTemperatureLabel,
            infoTemperatureLabel
        ].forEach { label in
            label.numberOfLines = 2
            label.textColor = .white
        }

        headerLabel.font = .systemFont(ofSize: 17, weight: .bold)
        subtitleLabel.font = .systemFont(ofSize: 13, weight: .light)
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        currentTemperatureLabel.font = .systemFont(ofSize: 45, weight: .thin)
        infoTemperatureLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        infoTemperatureLabel.textAlignment = .right
        
        icon.contentMode = .scaleAspectFit
        
        loadSpinner.color = .white
        loadSpinner.startAnimating()
    }
    
    //MARK: - Constraints
    func setupHeaderLabelConstraints() {
        headerLabel.anchor(
            top: container.topAnchor,
            leading: container.leadingAnchor,
            trailing: icon.leadingAnchor,
            paddingTop: Constans.topInset,
            paddingLeading: Constans.leftInset
        )
    }
    
    func setupSubtitleLabelConstraints() {
        subtitleLabel.anchor(
            top: headerLabel.bottomAnchor,
            leading: headerLabel.leadingAnchor,
            paddingTop: 2
        )
    }
    
    func setupDescriptionLabelConstraints() {
        descriptionLabel.anchor(
            bottom: container.bottomAnchor,
            leading: subtitleLabel.leadingAnchor,
            trailing: headerLabel.trailingAnchor,
            paddingBottom: Constans.bottomInset
        )
    }
    
    func setupCurrentTemperatureLabelConstraints() {
        currentTemperatureLabel.anchor(
            top: headerLabel.topAnchor,
            bottom: icon.bottomAnchor,
            leading: icon.trailingAnchor,
            trailing: container.trailingAnchor,
            paddingTrailing: Constans.rightInset
        )
    }
    
    func setupInfoTemperatureLabelConstraints() {
        infoTemperatureLabel.anchor(
            bottom: descriptionLabel.bottomAnchor,
            trailing: currentTemperatureLabel.trailingAnchor
        )
    }
    
    func setupIconConstraints() {
        icon.anchor(
            top: currentTemperatureLabel.topAnchor,
            bottom: infoTemperatureLabel.topAnchor,
            leading: container.centerXAnchor,
            paddingTrailing: 10
        )
        
        loadSpinner.centerX(inView: icon)
        loadSpinner.centerY(inView: icon)
    }
    
    //MARK: - Helpers
    func animatableConstraints(isActive: Bool) {
        [
            containerTopConstraint,
            containerBottomConstraint,
            containerLeadingConstraint,
            containerTrailingConstraint
        ].forEach { constraint in constraint?.isActive = isActive }
    }
    
    func setContainerConstraints(equalTo view: UIView, isDefault: Bool) {
        animatableConstraints(isActive: false)
        let leadingConstant = isDefault ? Constans.leftInset : 0
        let trailingConstant = isDefault ? -Constans.rightInset : 0
        
        containerTopConstraint = container.topAnchor.constraint(equalTo: view.topAnchor)
        containerBottomConstraint = container.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerLeadingConstraint = container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstant)
        containerTrailingConstraint = container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailingConstant)
        
        animatableConstraints(isActive: true)
    }
}
