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
            drawView.lines.removeAll(keepCapacity: false)
            
            for (index, row) in enumerate(liveQuery.rows.allObjects) {
                drawView.lines.append(Line(forDocument: (row as CBLQueryRow).document))
            }
            
            drawView.setNeedsDisplay()
        }
    }
    
    @IBAction func clearTap(sender: AnyObject) {
        drawView.lines.map { (line) -> Bool in
            line.deleteDocument(nil)
            return true
        }
        drawView.lines = []
        drawView.setNeedsDisplay()
    }
    
}