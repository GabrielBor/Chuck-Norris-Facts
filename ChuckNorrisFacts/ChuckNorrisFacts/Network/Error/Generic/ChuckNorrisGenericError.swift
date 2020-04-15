//
//  ChuckNorrisGenericError.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 14/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import Foundation

public enum ChuckNorrisGenericMessages: String {
    case parse = "Não foi possível fazer o parseamento do objeto"
    case generic, unknown = "Algo deu errado, tente novamente mais tarde."
    case notConnectedToInternet = "Sem conexão com a internet :(. Por favor verifique o seu wifi ou dados do dispositivo móvel."
}

public protocol ChuckNorrisGenericError: LocalizedError {
    var code: Int { get }
    var message: String { get }
}

public extension ChuckNorrisGenericError where Self: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.code == rhs.code
    }
}
