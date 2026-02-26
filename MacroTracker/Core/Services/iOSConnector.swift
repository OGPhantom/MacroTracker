//
//  iOSConnector.swift
//  MacroTracker
//
//  Created by Никита Сторчай on 26.02.2026.
//


import Foundation
import WatchConnectivity
import SwiftData

final class iOSConnector: NSObject, ObservableObject, WCSessionDelegate {

    static let shared = iOSConnector()
    var modelContainer: ModelContainer? {
        didSet {
            flushPendingPayloadsIfPossible()
        }
    }
    private var pendingPayloads: [[String: Any]] = []

    private override init() {
        super.init()

        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            print("iOS WCSession activated")
        }
    }

    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        print("iOS activation state:", activationState.rawValue)
        if let error {
            print("iOS activation error:", error.localizedDescription)
        }
        print("iOS watch paired:", session.isPaired, "watch app installed:", session.isWatchAppInstalled)
    }

    func session(_ session: WCSession,
                 didReceiveUserInfo userInfo: [String : Any]) {
        print("Received from Watch:", userInfo)
        saveMacro(from: userInfo)
    }

    func session(_ session: WCSession,
                 didReceiveMessage message: [String : Any]) {
        print("Received message from Watch:", message)
        saveMacro(from: message)
    }

    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}

    private func saveMacro(from payload: [String: Any]) {
        let food = payload["food"] as? String ?? "Not Found"
        let carbs = payload["carbs"] as? Int ?? 0
        let fats = payload["fats"] as? Int ?? 0
        let protein = payload["protein"] as? Int ?? 0

        let createdAt = dateValue(forKey: "createdAt", in: payload) ?? .now
        let date = dateValue(forKey: "date", in: payload) ?? .now

        guard let modelContainer else {
            pendingPayloads.append(payload)
            print("iOSConnector: modelContainer is nil, queued payload. Pending:", pendingPayloads.count)
            return
        }

        Task { @MainActor in
            let macro = Macro(
                food: food,
                createdAt: createdAt,
                date: date,
                carbs: carbs,
                fats: fats,
                protein: protein
            )

            modelContainer.mainContext.insert(macro)

            do {
                try modelContainer.mainContext.save()
                print("iOSConnector: macro saved to SwiftData")
            } catch {
                print("iOSConnector: failed to save macro:", error.localizedDescription)
            }
        }
    }

    func sessionWatchStateDidChange(_ session: WCSession) {
        print("iOS watch state changed. paired:", session.isPaired,
              "watchAppInstalled:", session.isWatchAppInstalled,
              "reachable:", session.isReachable)
    }

    private func dateValue(forKey key: String, in payload: [String: Any]) -> Date? {
        if let date = payload[key] as? Date {
            return date
        }

        if let timestamp = payload[key] as? TimeInterval {
            return Date(timeIntervalSince1970: timestamp)
        }

        if let timestamp = payload[key] as? Double {
            return Date(timeIntervalSince1970: timestamp)
        }

        if let timestamp = payload[key] as? Int {
            return Date(timeIntervalSince1970: TimeInterval(timestamp))
        }

        return nil
    }

    private func flushPendingPayloadsIfPossible() {
        guard modelContainer != nil, pendingPayloads.isEmpty == false else { return }
        let payloads = pendingPayloads
        pendingPayloads.removeAll()
        print("iOSConnector: flushing pending payloads:", payloads.count)
        for payload in payloads {
            saveMacro(from: payload)
        }
    }
}
