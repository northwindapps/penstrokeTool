import UIKit

class ViewController: BaseController, UICollectionViewDataSource, UICollectionViewDelegate {

    var collectionView: UICollectionView!
    var tapGestureRecognizer: UITapGestureRecognizer!
    var disableScrollTimer: Timer?

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
        
        
        // Add pan gesture recognizer to the collection view
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        // Disable scrolling
        collectionView.isScrollEnabled = false
        
        collectionView.isUserInteractionEnabled = true
    }
    
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let touchPoint = gesture.location(in: self.view)
        
        let indexPath = collectionView.indexPathForItem(at: touchPoint)
           
        if (indexPath == nil) {
            collectionView.isScrollEnabled = true
            startDisableScrollTimer()
        }
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
    
    func startDisableScrollTimer() {
        disableScrollTimer?.invalidate() // Invalidate previous timer if exists
        disableScrollTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            self!.collectionView.isScrollEnabled = false // Disable scrolling after 3 seconds
            self?.disableScrollTimer = nil // Clean up timer reference
        }
    }
        

    // MARK: - UICollectionViewDelegate

    // Implement delegate methods if needed
}

