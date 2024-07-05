import UIKit

protocol ScrollTableViewDelegate: AnyObject {
    func scrollToItem(to index: Int)
}

extension CalendarHorizontalView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.scrollToItem(to: indexPath.item)
    }
    
    func scrollToItem(_ index: Int) {
        collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: false)
        self.collectionView.selectItem(
            at: IndexPath(item: index, section: 0),
            animated: false,
            scrollPosition: []
        )
    }
}

extension CalendarHorizontalView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        source.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DateCell else {
            return UICollectionViewCell()
        }
        
        cell.day.text = source[indexPath.item].0
        cell.month.text = source[indexPath.item].1
        
        return cell
    }
}
