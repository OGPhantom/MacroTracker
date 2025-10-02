import Foundation
import WatchConnectivity
import SwiftData

class WatchConnector: NSObject, WCSessionDelegate, ObservableObject {
    
    var session: WCSession
    var modelContext: ModelContext? = nil
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        let macro = Macro(
                          food: message["food"] as? String ?? "Not Found",
                          createdAt: message["createdAt"] as? Date ?? Date.now,
                          date: message["date"] as? Date ?? Date.now,
                          carbs: message["carbs"] as? Int ?? 0,
                          fats: message["fats"] as? Int ?? 0,
                          protein: message["protein"] as? Int ?? 0
                        )
        modelContext?.insert(macro)
    }
}
