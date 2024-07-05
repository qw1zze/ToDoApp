import UIKit

protocol ScrollTableViewDelegate: AnyObject {
    func scrollToItem(to index: Int)
}

class CalendarHorizontalView: UIView {
    var collectionView: UICollectionView!
    
    var source: [(String, String)]
    
    var delegate: ScrollTableViewDelegate?
    
    init(days: [(String, String)]) {
        source = days
        super.init(frame: .zero)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupFlowLayout())
        
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: 70),
            
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: "cell")
        if source.count != 0 {
            collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
        }
    }
    
    func setupFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = .init(width: 70, height: 70)
        layout.scrollDirection = .horizontal
        
        return layout
    }
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
