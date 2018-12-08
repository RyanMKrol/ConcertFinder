//
//  EmailClient.swift
//  ConcertFinderLib
//
//  Created by Ryan Krol on 08/12/2018.
//
//  TV: Ashes To Ashes - Season 2 - Episode 8

import Foundation
import SwiftSMTP

public class EmailClient {

    private let fromEmail: Mail.User
    private let client: SMTP

    public init(config: EmailConfig) {
        self.fromEmail = Mail.User(email: config.emailAccount)
        self.client = SMTP(
            hostname: config.hostName,
            email: config.emailAccount,
            password: config.password
        )
    }

    public func sendMail(emailList: [String], content: String) {

        let waitTask = DispatchSemaphore(value: 0)
        let to = emailList.map({ Mail.User(email: $0) })

        let mail = Mail(
            from: self.fromEmail,
            to: to,
            subject: "Concerts for the week",
            text: content
        )

        self.client.send(mail) { (error) in
            if let error = error {
                print(error)
            }
            waitTask.signal()
        }
        waitTask.wait()
    }
}
