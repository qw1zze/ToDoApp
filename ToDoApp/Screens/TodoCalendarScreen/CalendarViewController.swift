import UIKit

class CalendarViewController: UIViewController {
    
    var collectionView: CalendarHorizontalView
    
    var tableView: CalendarTableView
    
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
        tableView.tableView.backgroundColor = .gray
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        tableView.tableView.backgroundColor = UIColor(Resources.Colors.Back.primary)
        collectionView.collectionView.backgroundColor = UIColor(Resources.Colors.Back.primary)
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
