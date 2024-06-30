import UIKit
import PencilKit

class ViewController: BaseController, UICollectionViewDataSource, UICollectionViewDelegate, UITabBarDelegate, UITextFieldDelegate {

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
        textField.placeholder = "Enter any annotation letter here"
        textField.delegate = self
        // Add target for editing changes (optional)
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
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
    
    
    // Function to handle text field changes
    @objc func textFieldDidChange(_ textField: UITextField) {
        // Handle text changes here
        if let text = textField.text {
            // Do something with the text, such as updating a model or UI
            print("Text changed to: \(text)")
            collectionView.reloadData()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()  // Dismiss keyboard
        return true
    }
    
    @objc func buttonTapped() {
        print("Add to the list")
        
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
        cell.button.setTitle("Item \(indexPath.row)", for: .normal)
        cell.button.tag = indexPath.row
        cell.customView.drawing = PKDrawing()
        cell.customView.tag = indexPath.row
        cell.customView.configure(withAnnotation: textField.text ?? "")
        // Custom view can be configured here if needed
        cell.button.addTarget(self, action: #selector(buttonTapped2), for: .touchUpInside)
        return cell
    }
    
    @objc func buttonTapped2(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell {
                let customView = cell.customView
                // Handle customView here
                print(customView)
                customView.drawing = PKDrawing()
            }
    }
    
    func startDisableScrollTimer() {
        disableScrollTimer?.invalidate() // Invalidate previous timer if exists
        disableScrollTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            self?.collectionView.isScrollEnabled = false // Disable scrolling after 3 seconds
            self?.disableScrollTimer = nil // Clean up timer reference
        }
    }
    
    // Detecting off-screen cells
//        func scrollViewDidScroll(_ scrollView: UIScrollView) {
//            let visibleIndexPaths = collectionView.indexPathsForVisibleItems
//            let totalItems = collectionView.numberOfItems(inSection: 0)
//            var allIndexPaths = [IndexPath]()
//            
//            for i in 0..<totalItems {
//                allIndexPaths.append(IndexPath(item: i, section: 0))
//            }
//            
//            let offScreenIndexPaths = allIndexPaths.filter { !visibleIndexPaths.contains($0) }
//            //print("Off-screen cells: \(offScreenIndexPaths.map { $0.row })")
//        }
        
    // MARK: - UICollectionViewDelegate

    // Implement delegate methods if needed
}
