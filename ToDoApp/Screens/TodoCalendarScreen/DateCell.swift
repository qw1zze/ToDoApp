import UIKit

class DateCell: UICollectionViewCell {
    var day = UILabel()
    var month = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    func setup() {
        self.contentView.addSubview(day)
        self.contentView.addSubview(month)
        
        day.translatesAutoresizingMaskIntoConstraints = false
        month.translatesAutoresizingMaskIntoConstraints = false
        
        day.adjustsFontSizeToFitWidth = true
        day.textAlignment = .center
        
        month.textAlignment = .center
        month.adjustsFontSizeToFitWidth = true
        
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 15
        
        NSLayoutConstraint.activate([
            day.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            day.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            day.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            month.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            month.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            month.topAnchor.constraint(equalTo: day.bottomAnchor),
            month.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
        ])
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .gray : .white
            self.contentView.layer.borderWidth = isSelected ? 2 : 0
        }
    }
}
