//
//  InterfaceController.swift
//  InteractiveMessagingSample WatchKit Extension
//
//  Created by koogawa on 2015/07/06.
//  Copyright © 2015年 Kosuke Ogawa. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var receivedMessageLabel: WKInterfaceLabel!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()

        // isSupported is not necessary, because session objects are always available on Apple Watch.
        let session = WCSession.defaultSession()
        session.delegate = self
        session.activateSession()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func sendMessageButtonTapped() {
        // Send message
        if (WCSession.defaultSession().reachable) {
            let message = ["hoge" : "huga"]
            WCSession.defaultSession().sendMessage(message,
                replyHandler: { (reply) -> Void in
                    dispatch_async(dispatch_get_main_queue(), {
                        self.receivedMessageLabel.setText("ok")
                    })
                },
                errorHandler: { (error) -> Void in
                    dispatch_async(dispatch_get_main_queue(), {
                        self.receivedMessageLabel.setText("error")
                    })
                }
            )
        }
    }

    // MARK: - WCSessionDelegate
    func sessionWatchStateDidChange(session: WCSession) {
        let text = session.reachable ? "reachable" : "unreachable"
        dispatch_async(dispatch_get_main_queue(), {
            self.receivedMessageLabel.setText(text)
        })
    }
}
