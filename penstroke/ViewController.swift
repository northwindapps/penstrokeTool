import UIKit

class ViewController: BaseController, UICollectionViewDataSource, UICollectionViewDelegate {

    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 180, height: 180)  // Adjust height for custom view
        
        // Initialize collection view
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Register custom cell class
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "customCell")
        
        // Add to view
        self.view.addSubview(collectionView)
        
        // Disable scrolling
        collectionView.isScrollEnabled = false
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 26 // Number of items
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        cell.backgroundColor = .clear
        cell.label.text = "Item \(indexPath.row)"
        // Custom view can be configured here if needed
        return cell
    }

    // MARK: - UICollectionViewDelegate

    // Implement delegate methods if needed
}

