import UIKit

class DateCell: UICollectionViewCell {
    static let reuseIdentifier = "dateCell"
    
    var dayLabel = UILabel()
    var monthLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        setupDay()
        setupMonth()
        
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 15
    }
    
    func setupDay() {
        self.contentView.addSubview(dayLabel)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.adjustsFontSizeToFitWidth = true
        dayLabel.textAlignment = .center
        dayLabel.font = .systemFont(ofSize: 17)
        dayLabel.textColor = UIColor(Resources.Colors.Label.secondary)
        
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dayLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func setupMonth() {
        self.contentView.addSubview(monthLabel)
        
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        monthLabel.textAlignment = .center
        monthLabel.adjustsFontSizeToFitWidth = true
        monthLabel.font = .systemFont(ofSize: 17)
        monthLabel.textColor = UIColor(Resources.Colors.Label.secondary)
        
        NSLayoutConstraint.activate([
            monthLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            monthLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            monthLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor),
            monthLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
        ])
    }
    
    func setupCell(day: String, month: String) {
        dayLabel.text = day
        monthLabel.text = month
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? UIColor(Resources.Colors.Back.IOSprimary) : UIColor(Resources.Colors.Back.primary)
            self.contentView.layer.borderWidth = isSelected ? 3 : 0
            self.contentView.layer.borderColor = isSelected ? CGColor(red: 0.560, green: 0.560, blue: 0.580, alpha: 1) : nil
        }
    }
}
