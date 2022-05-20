import Foundation
import UIKit

class DailyForecastCell: UITableViewCell {
    
    static let identifier = "DaysForecastCell"
    
    var viewModel: DailyTableCellViewModelType? {
        didSet {
            bind()
        }
    }
    
    private let day = UILabel()
    private let icon = UIImageView()
    private let temp_min = UILabel()
    private let separator: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "line"))
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    private let temp_max = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func bind() {
        viewModel?.day.bind({ [weak self] day in
            self?.day.text = day
        })
        
        viewModel?.dayIcon.bind({ [weak self] icon in
            self?.icon.image = icon
        })
        
        viewModel?.temp_min.bind({ [weak self] temp in
            self?.temp_min.text = temp
        })
        
        viewModel?.temp_max.bind({ [weak self] temp in
            self?.temp_max.text = temp
        })
    }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.addBlureEffect(style: .light)
        
        day.adjustsFontSizeToFitWidth = true
        day.textColor = .white
        temp_min.textColor = .white
        temp_max.textColor = .white
        
        let temperatureInfo = UIView()
        icon.contentMode = .scaleAspectFit
        
        [day, icon, temperatureInfo].forEach({ contentView.addSubview($0) })
        [temp_min, temp_max, separator].forEach({ temperatureInfo.addSubview($0) })
        
        day.anchor(top: contentView.topAnchor,
                   bottom: contentView.bottomAnchor,
                   leading: contentView.leadingAnchor,
                   trailing: icon.leadingAnchor,
                   paddingLeading: Constans.leftInset)
        
        icon.centerX(inView: contentView)
        icon.centerY(inView: contentView)
        icon.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        
        temperatureInfo.anchor(top: day.topAnchor,
                               bottom: day.bottomAnchor,
                               leading: icon.trailingAnchor,
                               trailing: contentView.trailingAnchor,
                               paddingTrailing: Constans.rightInset)
        
        temp_min.anchor(top: temperatureInfo.topAnchor,
                        bottom: temperatureInfo.bottomAnchor,
                        leading: temperatureInfo.leadingAnchor)
        
        separator.centerX(inView: temperatureInfo)
        separator.centerY(inView: temperatureInfo)
        separator.heightAnchor.constraint(equalTo: temperatureInfo.heightAnchor).isActive = true
        separator.widthAnchor.constraint(equalTo: temperatureInfo.widthAnchor, multiplier: 0.6).isActive = true
        
        temp_max.anchor(top: temp_min.topAnchor,
                        bottom: temp_min.bottomAnchor,
                        trailing: temperatureInfo.trailingAnchor)
    }
}
