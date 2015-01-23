import UIKit

class Line: CBLModel {
    var start: CGPoint {
        get {
            return CGPoint(x: x1, y: y1)
        }
    }
    var end: CGPoint {
        get {
            return CGPoint(x: x2, y: y2)
        }
    }
    @NSManaged var x1: CGFloat
    @NSManaged var y1: CGFloat
    @NSManaged var x2: CGFloat
    @NSManaged var y2: CGFloat
    
    init(start: CGPoint, end: CGPoint) {
        super.init(document: kDatabase.createDocument())
        
        x1 = start.x
        y1 = start.y
        x2 = end.x
        y2 = end.y
    }
    
    override init!(document: CBLDoc!) {
        super.init(document: document)
    }
    
}