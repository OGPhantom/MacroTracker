import Foundation
import WatchConnectivity

class WatchToiOSConnector: NSObject, WCSessionDelegate, ObservableObject {
    
    var session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sendMacroToiOS(macro: Macro) {
        if session.isReachable {
            let data: [String: Any] = [
                "food": macro.food,
                "createdAt": macro.createdAt,
                "date": macro.date,
                "carbs": macro.carbs,
                "fats": macro.fats,
                "protein": macro.protein
            ]
            
            session.sendMessage(data, replyHandler: nil) { error in
                print(error.localizedDescription)
            }
        } else {
            print("session is not reachable")
        }
    }
}


