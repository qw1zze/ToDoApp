import UIKit

class TodoCell: UITableViewCell {
    var textTask = UILabel()
    
    func setup() {
        self.addSubview(textTask)
        
        textTask.translatesAutoresizingMaskIntoConstraints = false
        
        textTask.numberOfLines = 3
        textTask.textAlignment = .left
        textTask.textColor = UIColor(Resources.Colors.Label.primary)
        
        self.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            textTask.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            textTask.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            textTask.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            textTask.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
        ])
    }
}
