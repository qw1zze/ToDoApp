import UIKit

protocol ScrollTableViewDelegate: AnyObject {
    func scrollToItem(to index: Int)
}

extension CalendarHorizontalView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.scrollToItem(to: indexPath.item)
    }
    
    func scrollToItem(_ index: Int) {
        collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: true)
        self.collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: [])
    }
}

extension CalendarHorizontalView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        source.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCell.reuseIdentifier, for: indexPath) as? DateCell else {
            return UICollectionViewCell()
        }

        cell.setupCell(day: source[indexPath.item].0, month: source[indexPath.item].1)
        
        return cell
    }
}
