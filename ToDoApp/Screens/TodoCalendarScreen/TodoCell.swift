import UIKit

class TodoCell: UITableViewCell {
    static let reuseIdentifier = "todoCell"
    
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
    
    func setupStyle(todo: TodoItem) {
        if todo.completed {
            self.textTask.attributedText = NSAttributedString(string: todo.text, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            self.textTask.textColor = UIColor(Resources.Colors.Label.tertiary)
        } else {
            self.textTask.attributedText = NSAttributedString(string: "", attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            self.textTask.text = todo.text
            self.textTask.textColor = UIColor(Resources.Colors.Label.primary)
        }
        
        if let ind = todo.category?.getInt() {
            switch ind {
            case 0:
                self.category.backgroundColor = UIColor(.red)
            case 1:
                self.category.backgroundColor = UIColor(.blue)
            case 2:
                self.category.backgroundColor = UIColor(.green)
            case 3:
                self.category.backgroundColor = .clear
                break
            default:
                break
            }
        }
    }
}
