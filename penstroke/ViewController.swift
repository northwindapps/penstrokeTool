import UIKit
import PencilKit
import MessageUI

class ViewController: BaseController, UICollectionViewDataSource, UICollectionViewDelegate, UITabBarDelegate, UITextFieldDelegate, MFMailComposeViewControllerDelegate{

    var collectionView: UICollectionView!
    var tapGestureRecognizer: UITapGestureRecognizer!
    var disableScrollTimer: Timer?
    var tabBar: UITabBar!
    var textField: UITextField!
    var label: UILabel!
    var button: UIButton!
    var counter: Int!
    var coordinatesData: [DataModel] = []
    var points: [PKStrokePoint] = []
    var pointsArray: [[PKStrokePoint]] = []
    
    struct DataModel: Codable {
        // Define properties matching the structure of your JSON data
        let xCoordinates: [String]
        let yCoordinates: [String]
        let frameHeight: String
        let traveledDistances: [String]
        let timeStamps: [String]
        let sampleTag: String
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        counter = 0
        // Initialize text field
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no          
        textField.smartInsertDeleteType = .no
        textField.placeholder = "Enter any annotation letter here"
        textField.delegate = self
        // Add target for editing changes (optional)
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // Initialize label
        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Item cnt:0"
        label.textAlignment = .center
        
        // Initialize button
        button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Editview", for: .normal)
        button.addTarget(self, action: #selector(buttonAddToList), for: .touchUpInside)
        
        // Add text field, label, and button to view
        self.view.addSubview(textField)
        self.view.addSubview(label)
        self.view.addSubview(button)
        
        
        // Initialize layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 140)  // Adjust height for custom view
       
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
        collectionView.isScrollEnabled = true
        collectionView.isUserInteractionEnabled = true
        
        // Initialize tab bar
        tabBar = UITabBar()
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        let exportIcon = UIImage(systemName: "square.and.arrow.up")
        let tabBarItem1 = UITabBarItem(title: "Export", image: exportIcon, tag: 0)
        tabBar.items = [tabBarItem1]
        tabBar.delegate = self
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        //TODO
        loadJSONL()
        // Assuming coordinatesData contains a list of DataModel instances
        for each in coordinatesData {
            // Create an array of PKStrokePoints for each item in coordinatesData
            let points = createStrokePoints(from: each)
            
            // Append this array to the pointsArray
            pointsArray.append(points)
        }
    }
    
    private func loadJSONL(){
        if let filePath = Bundle.main.path(forResource: "train copy380", ofType: "jsonl") {
            do {
                // Read the file contents as a string
                let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
                
                // Optional: Clean the file contents by removing escape characters like '\n'
                var cleanedContents = fileContents.replacingOccurrences(of: "\n", with: "")
                
                
                
                cleanedContents = cleanedContents.replacingOccurrences(of: "}{", with: "}!!!{")
                
                // Split the content by lines (if it's a JSONL file)
                let lines = cleanedContents.components(separatedBy: "!!!")
                
                // Parse each line (which is a separate JSON object)
                for line in lines {
                    if let data = line.data(using: .utf8) {
                        do {
                            // Decode the JSON into a DataModel object
                            let decoder = JSONDecoder()
                            let decodedObject = try decoder.decode(DataModel.self, from: data)
                            
                            // Now you can work with the decoded object
                            print(decodedObject)
                            self.coordinatesData.append(decodedObject)
                        } catch {
                            print("Error decoding JSON: \(error)")
                        }
                    }
                }
            } catch {
                print("Error reading file: \(error)")
            }
        }
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
    
    @objc func buttonAddToList() {
        print("move to editview")
        if let editVC = self.storyboard?.instantiateViewController(withIdentifier: "editview") as? EditViewController {
            editVC.modalPresentationStyle = .fullScreen
            self.present(editVC, animated: true, completion: nil)
        } else {
            print("Could not instantiate EditViewController")
        }
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
        if counter > 0{
            //let csvString = createCSV()
            //saveCSV(csvString: csvString, fileName: "data.csv")
            sendMail()
        }

    }
    
    func createJSON() -> Data?{
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        var indexPaths: [IndexPath] = []
        
        for row in 0..<numberOfItems {
            let indexPath = IndexPath(row: row, section: 0)
            indexPaths.append(indexPath)
        }
        
        for idx in indexPaths{
            if let cell = collectionView.cellForItem(at: idx) as? CustomCollectionViewCell {
                let customView = cell.customView
                // Handle customView here
                DataManagerRepository.shared.addDataManager(customView.copyDataManager() as! SharedDataManager)
            }
        }
        
        let jsonAry = DataManagerRepository.shared.sumAllData()
        // Print aggregated data
        print("Data Count: \(jsonAry.count)")
        print("Conter",String(counter))
        
        
        
        // Convert the dictionary to JSON
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted // Optional, for readability
            let jsonData = try encoder.encode(jsonAry)
            
            // Convert JSON data to a string
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
                return jsonData
            }
        } catch {
            print("Failed to encode data: \(error)")
        }
        
        return nil
    }
    
    func saveCSV(csvString: String, fileName: String) {
        let fileManager = FileManager.default
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            print("CSV saved successfully at \(fileURL)")
        } catch {
            print("Failed to save CSV: \(error)")
        }
    }
    
    func sendMail() {
        if MFMailComposeViewController.canSendMail() {
            let today: Date = Date()
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
            var date = dateFormatter.string(from: today)

            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self

            mail.setSubject("pen-stroke-data")
            
            let jsonData = createJSON()//createCSV()
            
            if jsonData == nil{
                return
            }
            mail.addAttachmentData(jsonData!, mimeType: "text/json", fileName: "pen_stroke_data_" + date + ".json")

            present(mail, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coordinatesData.count // Number of items
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = coordinatesData[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        cell.backgroundColor = .clear
        cell.button.setTitle("Reset Item \(indexPath.row) \(data.sampleTag)", for: .normal)
        cell.button.tag = indexPath.row
        cell.customView.drawing = PKDrawing()
        
        // Create an array of PKStroke objects based on coordinatesData
        let points: [PKStrokePoint] = pointsArray[indexPath.row]//createStrokePoints(from: data)
        
        // Create a PKStrokePath with the points
        let strokePath = PKStrokePath(controlPoints: points, creationDate: Date())
        
        // Create a PKStroke with the path (you can customize ink style)
        let ink = PKInk(.pen, color: .black) // example ink style
        let stroke = PKStroke(ink: ink, path: strokePath)
        
        // Add the stroke to a drawing
        let drawing = PKDrawing(strokes: [stroke])
                
        // Add the stroke to the canvas
        cell.customView.drawing = drawing
        
        cell.customView.tag = indexPath.row
        cell.customView.configure(withAnnotation: textField.text ?? "")
        // Custom view can be configured here if needed
        cell.button.addTarget(self, action: #selector(buttonClearView), for: .touchUpInside)
        return cell
    }
    
    // Helper function to create PKStrokePoints from the DataModel's coordinates
    func createStrokePoints(from data: DataModel) -> [PKStrokePoint] {
        var points: [PKStrokePoint] = []
        
        for (index, (x, y)) in zip(data.xCoordinates, data.yCoordinates).enumerated() {
            let xValue = CGFloat((x as NSString).doubleValue)
            let yValue = CGFloat((y as NSString).doubleValue)

            // Sample values for the required parameters
            let timeOffset: TimeInterval = Double(index) * 0.1  // example increment
            let size = CGSize(width: 5, height: 5)  // example size
            let opacity: CGFloat = 1.0  // full opacity
            let force: CGFloat = 1.0  // force value, this can be adjusted based on your data
            let azimuth: CGFloat = 0.0  // azimuth in radians, this would depend on your data
            let altitude: CGFloat = 0.0  // altitude in radians, this can be adjusted

            // Create the PKStrokePoint
            let point = PKStrokePoint(location: CGPoint(x: xValue, y: yValue),
                                      timeOffset: timeOffset,
                                      size: size,
                                      opacity: opacity,
                                      force: force,
                                      azimuth: azimuth,
                                      altitude: altitude)

            points.append(point)
        }
        
        return points
    }
    
    @objc func buttonClearView(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell {
            let customView = cell.customView
            // Handle customView here
            customView.drawing = PKDrawing()
            customView.deleteData()
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
