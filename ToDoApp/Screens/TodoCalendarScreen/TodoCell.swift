import UIKit

class TodoCell: UITableViewCell {
    var textTask = UILabel()
    var category = UIView()
    
    func setup() {
        self.addSubview(textTask)
        self.addSubview(category)
        
        textTask.translatesAutoresizingMaskIntoConstraints = false
        
        textTask.numberOfLines = 3
        textTask.textAlignment = .left
        textTask.textColor = UIColor(Resources.Colors.Label.primary)
        isUserInteractionEnabled = false
        
        self.clipsToBounds = true
        
        category.backgroundColor = .black
        category.layer.cornerRadius = 7
        category.layer.shadowOpacity = 0.3
        NSLayoutConstraint.activate([
            textTask.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            textTask.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            textTask.trailingAnchor.constraint(equalTo: category.leadingAnchor, constant: -15),
            textTask.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
        ])
        
        category.translatesAutoresizingMaskIntoConstraints = false
        
        self.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            category.centerYAnchor.constraint(equalTo: centerYAnchor),
            category.widthAnchor.constraint(equalToConstant: 15),
            category.heightAnchor.constraint(equalToConstant: 15),
            category.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
}
