import Foundation
import WatchConnectivity

final class WatchToiOSConnector: NSObject, WCSessionDelegate, ObservableObject {

    override init() {
        super.init()

        guard WCSession.isSupported() else { return }

        let session = WCSession.default
        session.delegate = self
        session.activate()
    }

    func sendMacroToiOS(macro: Macro) {
        let data: [String: Any] = [
            "food": macro.food,
            "createdAt": macro.createdAt.timeIntervalSince1970,
            "date": macro.date.timeIntervalSince1970,
            "carbs": macro.carbs,
            "fats": macro.fats,
            "protein": macro.protein
        ]

        WCSession.default.transferUserInfo(data)
        print("Transferred:", data)
    }

    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        print("WATCH activation:", activationState.rawValue)
    }
}


