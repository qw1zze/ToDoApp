import UIKit

class DateCell: UICollectionViewCell {
    var day = UILabel()
    var month = UILabel()
    
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
        self.contentView.addSubview(day)
        day.translatesAutoresizingMaskIntoConstraints = false
        day.adjustsFontSizeToFitWidth = true
        day.textAlignment = .center
        day.font = .systemFont(ofSize: 17)
        day.textColor = UIColor(Resources.Colors.Label.secondary)
        
        NSLayoutConstraint.activate([
            day.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            day.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            day.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func setupMonth() {
        self.contentView.addSubview(month)
        
        month.translatesAutoresizingMaskIntoConstraints = false
        month.textAlignment = .center
        month.adjustsFontSizeToFitWidth = true
        month.font = .systemFont(ofSize: 17)
        month.textColor = UIColor(Resources.Colors.Label.secondary)
        
        NSLayoutConstraint.activate([
            month.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            month.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            month.topAnchor.constraint(equalTo: day.bottomAnchor),
            month.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
        ])
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? UIColor(Resources.Colors.Back.IOSprimary) : UIColor(Resources.Colors.Back.primary)
            self.contentView.layer.borderWidth = isSelected ? 3 : 0
            self.contentView.layer.borderColor = isSelected ? CGColor(red: 0.560, green: 0.560, blue: 0.580, alpha: 1) : nil
        }
    }
}
