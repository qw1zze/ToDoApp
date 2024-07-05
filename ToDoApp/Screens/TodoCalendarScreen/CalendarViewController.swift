import UIKit

class CalendarViewController: UIViewController {
    
    var collectionView: CalendarHorizontalView
    
    var tableView: CalendarTableView
    
    var tableViewActive: Bool = false
    
    var sourcee: [(String, String)] = [("30", "июня"), ("10", "июля"), ("12", "июля"), ("25", "июля"), ("30", "июля"), ("sad", "")]
    
    var source: [((String, String), [String])] = []
    
    init(source: [((String, String), [String])]) {
        self.source = source
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
    
}

extension CalendarViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleSections = tableView.tableView.indexPathsForVisibleRows?.map { $0.section } ?? []
        if let firstVisibleSection = visibleSections.first {
            collectionView.scrollToItem(firstVisibleSection)
        }
    }
}
