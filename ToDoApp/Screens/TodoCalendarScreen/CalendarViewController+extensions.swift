import Foundation
import SwiftUI

//Mark: - addNewButton action
extension CalendarViewController {
    @objc
    func addNewTodo() {
        let swiftUIHostingController = UIHostingController(rootView: TodoItemView(viewModel: TodoItemViewModel(todoItem: nil, fileCache: viewModel.fileCache), delegate: self))
        present(swiftUIHostingController, animated: true)
    }
}

//Mark: - Realize update list delegate protocol
extension CalendarViewController: updateListDelegate {
    func update() {
        viewModel.updateItems()
        self.tableView.source = self.viewModel.source.map({ ("\($0.0.0)\($0.0.1)", $0.1) })
        self.collectionView.source = self.viewModel.source.map({ $0.0 })
        self.tableView.tableView.reloadData()
        self.collectionView.collectionView.reloadData()
        if self.viewModel.source.count != 0 {
            self.collectionView.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
        }
    }
}

//Mark: - Realize scroll for tableView from collectionView
extension CalendarViewController: ScrollTableViewDelegate {
    func scrollToItem(to index: Int) {
        tableView.tableView.scrollToRow(at: IndexPath(item: 0, section: index), at: .top, animated: true)
    }
}

//Mark: - Realize swiping tableViewCells
extension CalendarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completeAction = UIContextualAction(style: .normal, title: nil) { _, _, completion in
            
            let item = self.viewModel.source[indexPath.section].1[indexPath.row]
            self.tableView.source[indexPath.section].1[indexPath.row] = self.viewModel.completeTask(item)
            tableView.reloadRows(at: [indexPath], with: .fade)
            completion(true)
        }
        completeAction.image = UIImage(systemName: "checkmark.circle")
        completeAction.backgroundColor = UIColor(Resources.Colors.green)
        
        let config = UISwipeActionsConfiguration(actions: [completeAction])
        return config
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let uncompleteAction = UIContextualAction(style: .normal, title: nil) { _, _, completion in
            let item = self.viewModel.source[indexPath.section].1[indexPath.row]

            self.tableView.source[indexPath.section].1[indexPath.row] = self.viewModel.uncompleteTask(item)
            tableView.reloadRows(at: [indexPath], with: .fade)
            completion(true)
        }
        uncompleteAction.image = UIImage(systemName: "xmark.circle")
        uncompleteAction.backgroundColor = UIColor(Resources.Colors.red)
        
        let config = UISwipeActionsConfiguration(actions: [uncompleteAction])
        return config
    }
}

//Mark: - Realize scroll collectionView from tableView
extension CalendarViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.isTracking || scrollView.isDragging || scrollView.isDecelerating) {
            if let section = tableView.tableView.indexPathsForVisibleRows?.first {
                collectionView.scrollToItem(section.section)
            }
        }
    }
}
