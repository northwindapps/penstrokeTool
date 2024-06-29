import UIKit

class ViewController: BaseController, UICollectionViewDataSource, UICollectionViewDelegate, UITabBarDelegate {

    var collectionView: UICollectionView!
    var tapGestureRecognizer: UITapGestureRecognizer!
    var disableScrollTimer: Timer?
    var tabBar: UITabBar!
    var textField: UITextField!
    var label: UILabel!
    var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize text field
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter text here"
        
        // Initialize label
        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Label below text field"
        label.textAlignment = .center
        
        // Initialize button
        button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add to the list", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        // Add text field, label, and button to view
        self.view.addSubview(textField)
        self.view.addSubview(label)
        self.view.addSubview(button)
        
        
        // Initialize layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 180, height: 180)  // Adjust height for custom view
       
        // Initialize collection view
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
       
        // Register custom cell class
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "customCell")
       
        // Add collection view to view
        self.view.addSubview(collectionView)
        
        // Add tap gesture recognizer to the collection view
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        collectionView.addGestureRecognizer(tapGestureRecognizer)
        
        // Disable scrolling
        collectionView.isScrollEnabled = false
        collectionView.isUserInteractionEnabled = true
        
        // Initialize tab bar
        tabBar = UITabBar()
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        let tabBarItem1 = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        let tabBarItem2 = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        tabBar.items = [tabBarItem1, tabBarItem2]
        tabBar.delegate = self // Set the delegate
        
        // Add tab bar to view
        self.view.addSubview(tabBar)

        // Activate constraints
        NSLayoutConstraint.activate([
            // Text field constraints
            textField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            textField.heightAnchor.constraint(equalToConstant: 40),
            
            // Label constraints
            label.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            label.heightAnchor.constraint(equalToConstant: 30),
            
            // Button constraints
            button.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            button.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 10),
            button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            button.widthAnchor.constraint(equalToConstant: 150),
            
            // Collection view constraints
            collectionView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            
            // Tab bar constraints
            tabBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tabBar.heightAnchor.constraint(equalToConstant: 49) // Default height for UITabBar
        ])
    }
    
    @objc func buttonTapped() {
        print("Button tapped!")
        // Handle button tap action here
    }
    
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let touchPoint = gesture.location(in: self.view)
        
        if let indexPath = collectionView.indexPathForItem(at: touchPoint) {
            // Handle tap on collection view item if needed
        } else {
            collectionView.isScrollEnabled = true
            startDisableScrollTimer()
        }
    }
    
    // UITabBarDelegate method
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item: \(item.tag)")
        // Handle tab bar item selection
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10 // Number of items
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        cell.backgroundColor = .clear
        cell.label.text = "Item \(indexPath.row)"
        cell.customView.tag = indexPath.row
        // Custom view can be configured here if needed
        return cell
    }
    
    func startDisableScrollTimer() {
        disableScrollTimer?.invalidate() // Invalidate previous timer if exists
        disableScrollTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            self?.collectionView.isScrollEnabled = false // Disable scrolling after 3 seconds
            self?.disableScrollTimer = nil // Clean up timer reference
        }
    }
    
    // Detecting off-screen cells
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let visibleIndexPaths = collectionView.indexPathsForVisibleItems
            let totalItems = collectionView.numberOfItems(inSection: 0)
            var allIndexPaths = [IndexPath]()
            
            for i in 0..<totalItems {
                allIndexPaths.append(IndexPath(item: i, section: 0))
            }
            
            let offScreenIndexPaths = allIndexPaths.filter { !visibleIndexPaths.contains($0) }
            print("Off-screen cells: \(offScreenIndexPaths.map { $0.row })")
        }
        
    // MARK: - UICollectionViewDelegate

    // Implement delegate methods if needed
}
