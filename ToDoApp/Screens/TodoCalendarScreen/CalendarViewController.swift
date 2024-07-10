import UIKit
import SwiftUI

class CalendarViewController: UIViewController {
    var viewModel: CalendarViewModel
    
    var collectionView: CalendarHorizontalView
    
    var tableView: CalendarMainView
    
    var button: UIButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "plus.circle.fill")
        configuration.imagePadding = 0
        configuration.imagePlacement = .all
        
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 40)

        button.configuration = configuration
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 4
        button.layer.cornerRadius = 24
        button.layer.masksToBounds = false
        button.layer.backgroundColor = .init(red: 1, green: 1, blue: 1, alpha: 1)
        return button
    }()
    
    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        collectionView = CalendarHorizontalView(days: self.viewModel.source.map({ ($0.day, $0.month) }))
        tableView = CalendarMainView(source: self.viewModel.source.map({ ("\($0.day)\($0.month)", $0.todoItems) }))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        collectionView.delegate = self
        tableView.tableView.delegate = self
    }
    
    func setup() {
        setupCollectionView()
        setupTableView()
        setupAddButton()
    }

    func setupCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: 92),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func setupAddButton() {
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
        button.addTarget(self, action: #selector(addNewTodo), for: .touchUpInside)
    }
}
