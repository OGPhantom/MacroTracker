//
//  WatchSessionManager.swift
//  MacroTracker
//
//  Created by Никита Сторчай on 26.02.2026.
//


import WatchConnectivity

final class WatchSessionManager: NSObject, ObservableObject, WCSessionDelegate {

    static let shared = WatchSessionManager()

    private override init() {
        super.init()

        guard WCSession.isSupported() else { return }

        let session = WCSession.default
        session.delegate = self
        session.activate()

        print("WATCH activated:", session.activationState.rawValue)
        print("WATCH companion installed:", session.isCompanionAppInstalled, "reachable:", session.isReachable)
    }

    func send(_ data: [String: Any]) {
        let session = WCSession.default

        if session.isReachable {
            session.sendMessage(data, replyHandler: nil) { error in
                print("WATCH sendMessage failed:", error.localizedDescription)
            }
        } else {
            print("WATCH sendMessage skipped: iPhone not reachable")
        }

        let transfer = session.transferUserInfo(data)
        print("Queued userInfo transfer:", transfer, data)
    }

    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        print("WATCH activation:", activationState.rawValue)
        if let error {
            print("WATCH activation error:", error.localizedDescription)
        }
        print("WATCH companion installed:", session.isCompanionAppInstalled, "reachable:", session.isReachable)
    }

    func session(_ session: WCSession,
                 didFinish userInfoTransfer: WCSessionUserInfoTransfer,
                 error: Error?) {
        if let error {
            print("WATCH transfer failed:", error.localizedDescription)
            return
        }

        print("WATCH transfer delivered:", userInfoTransfer.userInfo)
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        print("WATCH reachability changed:", session.isReachable)
    }
}
