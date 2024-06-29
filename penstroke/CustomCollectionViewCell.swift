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
    
    let customView: CustomCanvasView = {
        var view = CustomCanvasView()
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

class CustomCanvasView: PKCanvasView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            let location = touch.location(in: self)
            print("tag: \(self.tag)")
            print("Touch began at: \(location)")
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first {
            let location = touch.location(in: self)
            print("Touch moved to: \(location)")
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let touch = touches.first {
            let location = touch.location(in: self)
            print("Touch ended at: \(location)")
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if let touch = touches.first {
            let location = touch.location(in: self)
            print("Touch cancelled at: \(location)")
        }
    }
    
    func addStroke(at points: [CGPoint], with color: UIColor = .black, width: CGFloat = 5.0) {
            let newStroke = createStroke(at: points, with: color, width: width)
            var currentDrawing = self.drawing
            currentDrawing.strokes.append(newStroke)
            self.drawing = currentDrawing
    }
    
    func createStroke(at points: [CGPoint], with color: UIColor = .black, width: CGFloat = 5.0) -> PKStroke {
        let ink = PKInk(.pen, color: color)
        var controlPoints = [PKStrokePoint]()

        for point in points {
            let strokePoint = PKStrokePoint(location: point, timeOffset: 0, size: CGSize(width: width, height: width), opacity: 1.0, force: 1.0, azimuth: 0, altitude: 0)
            controlPoints.append(strokePoint)
        }

        let path = PKStrokePath(controlPoints: controlPoints, creationDate: Date())
        let stroke = PKStroke(ink: ink, path: path, transform: .identity, mask: nil)

        return stroke
    }
    
}
