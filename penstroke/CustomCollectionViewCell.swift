import UIKit
import PencilKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let customView: PKCanvasView = {
        var view = PKCanvasView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.minimumZoomScale = 1.0
        view.maximumZoomScale = 1.0
        view.layer.borderWidth = 1.0
        view.allowsFingerDrawing = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        contentView.addSubview(customView)
        
        // Set up constraints for the label
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // Set up constraints for the custom view
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            customView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            customView.widthAnchor.constraint(equalToConstant: 150),
            customView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

