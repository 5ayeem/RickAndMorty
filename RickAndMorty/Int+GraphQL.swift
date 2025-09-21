//
//  Int+GraphQL.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 21/09/2025.
//

import ApolloAPI

extension Int {
    var toGraphQLNullable: GraphQLNullable<Int> {
        GraphQLNullable<Int>(integerLiteral: self)
    }
}
