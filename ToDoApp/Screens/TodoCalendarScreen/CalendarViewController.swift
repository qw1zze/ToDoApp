import UIKit
import SwiftUI

class CalendarViewController: UIViewController {
    
    var collectionView: CalendarHorizontalView
    
    var tableView: CalendarTableView
    
    var button: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 4
        button.layer.cornerRadius = 24
        button.backgroundColor = UIColor(Resources.Colors.blue)
        return button
    }()
    
    var source: [((String, String), [TodoItem])] = []
    var viewModel: CalendarViewModel
    
    init(source: [((String, String), [TodoItem])], viewModel: CalendarViewModel) {
        self.source = source
        self.viewModel = viewModel
        collectionView = CalendarHorizontalView(days: source.map({ $0.0 }))
        tableView = CalendarTableView(source: source.map({ ("\($0.0.0)\($0.0.1)", $0.1) }))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
        collectionView.delegate = self
        tableView.tableView.delegate = self
    }
    
    func convertSource(_ items: [TodoItem]) -> [((String, String), [TodoItem])] {
        var source = [((String, String), [TodoItem])]()
        items.forEach { item in
            guard let deadline = item.deadline else {
                if let ind = source.firstIndex(where: { $0.0.0 == "Другое" }) {
                    source[ind].1.append(item)
                } else {
                    source.append((("Другое", ""), [item]))
                }
                return
            }
            
            if let ind = source.firstIndex(where: { $0.0.0 == deadline.getDayAndMonth().0 && $0.0.1 == deadline.getDayAndMonth().1 }) {
                source[ind].1.append(item)
            } else {
                source.append(((deadline.getDayAndMonth().0, deadline.getDayAndMonth().1), [item]))
            }
        }
        source.sort { first, second in
            first.0.0 < second.0.0
        }

        if let ind = source.firstIndex(where: { $0.0.0 == "Другое" }) {
            let item = source[ind]
            source.remove(at: ind)
            source.append(item)
        }
        return source
    }

    func setupCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: 70),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        tableView.tableView.backgroundColor = UIColor(Resources.Colors.Back.primary)
        collectionView.collectionView.backgroundColor = UIColor(Resources.Colors.Back.primary)
        
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 50),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
        button.addTarget(self, action: #selector(addnewTodo), for: .touchUpInside)
    }
}

extension CalendarViewController {
    @objc
    func addnewTodo() {
        @State var isShown: Bool = true
        let swiftUIHostingController = UIHostingController(rootView: TodoItemView(delegate: self, viewModel: TodoItemViewModel(todoItem: nil, fileCache: viewModel.fileCache), isShown: $isShown))
        present(swiftUIHostingController, animated: true)
    }
}

extension CalendarViewController: updateListDelegate {
    func update() {
        self.source = self.convertSource(self.viewModel.fileCache.todoItems)
        self.tableView.source = self.source.map({ ("\($0.0.0)\($0.0.1)", $0.1) })
        self.collectionView.source = self.source.map({ $0.0 })
        self.tableView.tableView.reloadData()
        self.collectionView.collectionView.reloadData()
        if self.source.count != 0 {
            self.collectionView.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
        }
    }
}

extension CalendarViewController: ScrollTableViewDelegate {
    func scrollToItem(to index: Int) {
        tableView.tableView.scrollToRow(at: IndexPath(item: 0, section: index), at: .top, animated: false)
    }
}

extension CalendarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completeAction = UIContextualAction(style: .normal, title: nil) { _, _, completion in
            
            let item = self.source[indexPath.section].1[indexPath.row]

            self.tableView.source[indexPath.section].1[indexPath.row] = self.viewModel.completeTask(item)
            
            completion(true)
        }
        tableView.reloadData()
        completeAction.image = UIImage(systemName: "checkmark.circle")
        completeAction.backgroundColor = UIColor(Resources.Colors.green)
        
        let config = UISwipeActionsConfiguration(actions: [completeAction])
        return config
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let uncompleteAction = UIContextualAction(style: .normal, title: nil) { _, _, completion in
            let item = self.source[indexPath.section].1[indexPath.row]

            self.tableView.source[indexPath.section].1[indexPath.row] = self.viewModel.uncompleteTask(item)
            print(self.tableView.source[indexPath.section].1[indexPath.row])
            
            completion(true)
        }
        tableView.reloadData()
        uncompleteAction.image = UIImage(systemName: "xmark.circle")
        uncompleteAction.backgroundColor = UIColor(Resources.Colors.red)
        
        let config = UISwipeActionsConfiguration(actions: [uncompleteAction])
        return config
    }
}

extension CalendarViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleSections = tableView.tableView.indexPathsForVisibleRows?.map { $0.section } ?? []
        if let firstVisibleSection = visibleSections.first {
            collectionView.scrollToItem(firstVisibleSection)
        }
    }
}
