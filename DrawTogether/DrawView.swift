import UIKit

class DrawView: UIView {
    
    var lines: [Line] = []
    var lastPoint: CGPoint!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        lastPoint = touches.anyObject()?.locationInView(self)
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        var newPoint = touches.anyObject()?.locationInView(self)
        let newLine = Line(start: lastPoint, end: newPoint!)
        newLine.save(nil)
        lastPoint = newPoint
    }
    
    override func drawRect(rect: CGRect) {
        var context = UIGraphicsGetCurrentContext()
        CGContextBeginPath(context)
        for line in lines {
            CGContextMoveToPoint(context, line.start.x, line.start.y)
            CGContextAddLineToPoint(context, line.end.x, line.end.y)
        }
        CGContextSetLineCap(context, kCGLineCapRound)
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1)
        CGContextSetLineWidth(context, 5)
        CGContextStrokePath(context)
    }
    
}