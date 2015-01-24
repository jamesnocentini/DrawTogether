import UIKit

class DrawView: UIView {
    
    var lines: [Line] = []
    var polylines: [Polyline] = []
    var lastPoint: CGPoint!
    var lastPolyline: Polyline = Polyline()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        lastPolyline = Polyline()
        lastPoint = touches.anyObject()?.locationInView(self)
        let point = ["x" : lastPoint.x, "y" : lastPoint.y]
        lastPolyline.points.append(point)
        polylines.append(lastPolyline)
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        lastPoint = touches.anyObject()?.locationInView(self)
        let point = ["x" : lastPoint.x, "y" : lastPoint.y]
        lastPolyline.points.append(point)
        setNeedsDisplay()
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        lastPolyline.save(nil)
    }
    
    override func drawRect(rect: CGRect) {
        var context = UIGraphicsGetCurrentContext()
        CGContextBeginPath(context)
        
        for polyline in polylines {
            if let firstPoint = polyline.points.first {
                CGContextMoveToPoint(context, firstPoint["x"]!, firstPoint["y"]!)
            }
            
            for point in polyline.points {
                CGContextAddLineToPoint(context, point["x"]!, point["y"]!)
            }
        }
        
        
        
//        for line in lines {
//            CGContextMoveToPoint(context, line.start.x, line.start.y)
//            CGContextAddLineToPoint(context, line.end.x, line.end.y)
//        }
        CGContextSetLineCap(context, kCGLineCapRound)
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1)
        CGContextSetLineWidth(context, 5)
        CGContextStrokePath(context)
    }
    
}