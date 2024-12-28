//
//  SGErrors.swift
//  SwiftGithub
//
//  Created by Sultan on 27/12/24.
//

import Foundation

struct SGError: Error {
    init(_ message: SGErrorMessage) {
        self.message = message
    }

    let message: SGErrorMessage
}

enum SGErrorMessage: String {
    case invalidUsername = "This username created an invalid request. Please try again"
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again"
    case invalidData = "The data received from the server is invalid. Please try again"
}
