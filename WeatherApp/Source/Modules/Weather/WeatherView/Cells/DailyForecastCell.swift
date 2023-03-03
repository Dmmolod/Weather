import UIKit

final class DailyForecastCell: UITableViewCell {
    private let dayTitle = UILabel()
    private let icon = UIImageView()
    private let tempMin = UILabel()
    private let tempMax = UILabel()
    private let loadSpinner = UIActivityIndicatorView(style: .medium)
    
    private let separator: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "line"))
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        loadSpinner.startAnimating()
        loadSpinner.isHidden = false
    }
    
    func configure(_ model: DailyTableCellViewModelType) {
        dayTitle.text = model.day
        tempMax.text = model.tempMax
        tempMin.text = model.tempMin
        
        model.dayIcon.bind { [weak self] dayIcon in
            self?.loadSpinner.stopAnimating()
            self?.loadSpinner.isHidden = true
            self?.icon.image = dayIcon
        }
    }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.addBlureEffect(style: .light)
        
        dayTitle.adjustsFontSizeToFitWidth = true
        dayTitle.textColor = .white
        tempMin.textColor = .white
        tempMax.textColor = .white
        
        let temperatureInfo = UIView()
        icon.contentMode = .scaleAspectFit
        loadSpinner.color = .white
        loadSpinner.startAnimating()
        
        [dayTitle, icon, loadSpinner, temperatureInfo].forEach({ contentView.addSubview($0) })
        [tempMin, tempMax, separator].forEach({ temperatureInfo.addSubview($0) })
        
        dayTitle.anchor(
            top: contentView.topAnchor,
            bottom: contentView.bottomAnchor,
            leading: contentView.leadingAnchor,
            trailing: icon.leadingAnchor,
            paddingLeading: Constans.leftInset
        )
        
        icon.centerX(inView: contentView)
        icon.centerY(inView: contentView)
        icon.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        loadSpinner.centerX(inView: icon)
        loadSpinner.centerY(inView: icon)
        loadSpinner.widthAnchor.constraint(equalTo: icon.widthAnchor).isActive = true
        
        temperatureInfo.anchor(
            top: dayTitle.topAnchor,
            bottom: dayTitle.bottomAnchor,
            leading: icon.trailingAnchor,
            trailing: contentView.trailingAnchor,
            paddingTrailing: Constans.rightInset
        )
        
        tempMin.anchor(
            top: temperatureInfo.topAnchor,
            bottom: temperatureInfo.bottomAnchor,
            leading: temperatureInfo.leadingAnchor
        )
        
        separator.centerX(inView: temperatureInfo)
        separator.centerY(inView: temperatureInfo)
        separator.heightAnchor.constraint(equalTo: temperatureInfo.heightAnchor).isActive = true
        separator.widthAnchor.constraint(equalTo: temperatureInfo.widthAnchor, multiplier: 0.6).isActive = true
        
        tempMax.anchor(
            top: tempMin.topAnchor,
            bottom: tempMin.bottomAnchor,
            trailing: temperatureInfo.trailingAnchor
        )
    }
}
