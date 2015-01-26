import UIKit

class ViewController: UIViewController {

    var drawImage = UIImageView()
    var polylines: [Polyline] = []
    var currentPolyline: Polyline!
    var lastPoint: CGPoint!
    var liveQuery: CBLLiveQuery!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        liveQuery = kDatabase.createAllDocumentsQuery().asLiveQuery()
        liveQuery.addObserver(self, forKeyPath: "rows", options: .allZeros, context: nil)
        liveQuery.run(nil)
        
        drawImage.frame = view.bounds
        view.addSubview(drawImage)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        lastPoint = touches.anyObject()?.locationInView(view)
        currentPolyline = Polyline()
        currentPolyline.points.append(["x" : lastPoint.x, "y" : lastPoint.y])
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let point = touches.anyObject()!.locationInView(view)
        currentPolyline.points.append(["x" : point.x, "y" : point.y])
        
        UIGraphicsBeginImageContext(view.bounds.size)
        drawImage.image?.drawInRect(view.bounds)
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0)
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0, 0, 0, 1)
        CGContextBeginPath(UIGraphicsGetCurrentContext())
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y)
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), point.x, point.y)
        CGContextStrokePath(UIGraphicsGetCurrentContext())
        drawImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        lastPoint = point
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        currentPolyline.save(nil)
    }
    
    @IBAction func clearTap(sender: AnyObject) {
        for polyline in polylines {
            polyline.deleteDocument(nil)
        }
        polylines = []
        drawImage.image = nil
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if (object as CBLLiveQuery) == liveQuery {
            polylines.removeAll(keepCapacity: false)
            
            for (index, row) in enumerate(liveQuery.rows.allObjects) {
                polylines.append(Polyline(forDocument: (row as CBLQueryRow).document))
            }
            
            drawPolylines()
        }
    }
    
    func drawPolylines() {
        drawImage.image = nil
        UIGraphicsBeginImageContext(view.bounds.size)
        drawImage.image?.drawInRect(view.bounds)
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0)
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0, 0, 0, 1)
        CGContextBeginPath(UIGraphicsGetCurrentContext())
        
        for polyline in polylines {
            if let firstPoint = polyline.points.first {
                CGContextMoveToPoint(UIGraphicsGetCurrentContext(), firstPoint["x"]!, firstPoint["y"]!)
            }
            
            for point in polyline.points {
                CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), point["x"]!, point["y"]!)
            }
        }

        CGContextStrokePath(UIGraphicsGetCurrentContext())
        drawImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
}