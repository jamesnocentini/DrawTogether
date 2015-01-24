import UIKit

class ViewController: UIViewController {
    

    @IBOutlet var drawView: DrawView!
    var liveQuery: CBLLiveQuery!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        liveQuery = kDatabase.createAllDocumentsQuery().asLiveQuery()
        liveQuery.addObserver(self, forKeyPath: "rows", options: .allZeros, context: nil)
        liveQuery.run(nil)
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if (object as CBLLiveQuery) == liveQuery {
            drawView.polylines.removeAll(keepCapacity: false)
            
            for (index, row) in enumerate(liveQuery.rows.allObjects) {
                drawView.polylines.append(Polyline(forDocument: (row as CBLQueryRow).document))
            }
            
            drawView.setNeedsDisplay()
        }
    }
    
    @IBAction func clearTap(sender: AnyObject) {
        drawView.polylines.map { (polyline) -> Bool in
            polyline.deleteDocument(nil)
            return true
        }
        drawView.polylines = []
        drawView.setNeedsDisplay()
    }
    
}