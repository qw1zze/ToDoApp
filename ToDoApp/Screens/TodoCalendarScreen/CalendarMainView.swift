import UIKit

class CalendarMainView: UIView {
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
        tableView.register(TodoCell.self, forCellReuseIdentifier: TodoCell.reuseIdentifier)

        setupLayout()
    }

    func setupLayout() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        tableView.backgroundColor = UIColor(Resources.Colors.Back.primary)
    }
}

extension CalendarMainView: UITableViewDelegate { }

extension CalendarMainView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        source.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        source[section].1.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.reuseIdentifier,
                                                       for: indexPath) as? TodoCell else {
            return UITableViewCell()
        }

        cell.setup()

        cell.setupStyle(todo: source[indexPath.section].1[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        source[section].0
    }
}
