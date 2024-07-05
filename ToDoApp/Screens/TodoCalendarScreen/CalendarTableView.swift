import UIKit

class CalendarTableView: UIView {
    var tableView: UITableView!
    
    var source: [(String, [TodoItem])]
    
    init(source: [(String, [TodoItem])]) {
        self.source = source
        super.init(frame: .zero)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTableView() {
        tableView = UITableView(frame: self.frame, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TodoCell.self, forCellReuseIdentifier: "todoCell")
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

extension CalendarTableView: UITableViewDelegate {
}

extension CalendarTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        source.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        source[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as? TodoCell else {
            return UITableViewCell()
        }
        cell.setup()
        if source[indexPath.section].1[indexPath.row].completed {
            cell.textTask.attributedText = NSAttributedString(string: source[indexPath.section].1[indexPath.row].text, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            cell.textTask.textColor = UIColor(Resources.Colors.Label.tertiary)
        } else {
            cell.textTask.attributedText = NSAttributedString(string: "", attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            cell.textTask.text = source[indexPath.section].1[indexPath.row].text
            cell.textTask.textColor = UIColor(Resources.Colors.Label.primary)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        source[section].0
    }
}
