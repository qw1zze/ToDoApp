import UIKit

class CalendarHorizontalView: UIView {
    var source: [(String, String)]

    var delegate: ScrollTableViewDelegate?

    var collectionView: UICollectionView!

    var topDivider: UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor(Resources.Colors.grayLight)
        return divider
    }()

    var bottomDivider: UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor(Resources.Colors.grayLight)
        return divider
    }()

    init(days: [(String, String)]) {
        source = days
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        setupTopDivider()
        setupCollectionView()
        setupBottomDivider()
    }

    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupFlowLayout())

        addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: DateCell.reuseIdentifier)

        self.backgroundColor = UIColor(Resources.Colors.Back.primary)
        collectionView.backgroundColor = UIColor(Resources.Colors.Back.primary)
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: 70),
            collectionView.topAnchor.constraint(equalTo: topDivider.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])

        if source.count != 0 {
            collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
        }
    }

    func setupTopDivider() {
        addSubview(topDivider)

        topDivider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topDivider.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topDivider.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            topDivider.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            topDivider.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    func setupBottomDivider() {
        addSubview(bottomDivider)

        bottomDivider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomDivider.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            bottomDivider.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            bottomDivider.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            bottomDivider.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    func setupFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()

        layout.itemSize = .init(width: 70, height: 70)
        layout.scrollDirection = .horizontal

        return layout
    }
}
