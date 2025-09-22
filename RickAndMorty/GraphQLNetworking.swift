//
//  GraphQLNetworking.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 21/09/2025.
//

import Apollo
import Foundation
import RickAndMortyAPI

protocol GraphQLNetworking {
    @discardableResult
    func fetch<Q: GraphQLQuery>(
        _ query: Q,
        cachePolicy: CachePolicy
    ) async throws -> GraphQLResult<Q.Data>

    @discardableResult
    func perform<M: GraphQLMutation>(
        _ mutation: M
    ) async throws -> GraphQLResult<M.Data>
}

final class DefaultGraphQLNetworking: GraphQLNetworking {
    
    // MARK: - Properties
    private let client: ApolloClientProtocol

    // MARK: - Initializers
    init(client: ApolloClientProtocol) {
        self.client = client
    }

    convenience init(endpoint: URL) {
        let store = ApolloStore()
        let urlSession = URLSessionClient()
        let provider = DefaultInterceptorProvider(client: urlSession, store: store)
        let transport = RequestChainNetworkTransport(interceptorProvider: provider,
                                                     endpointURL: endpoint)
        let client = ApolloClient(networkTransport: transport, store: store)
        self.init(client: client)
    }

    // MARK: - Async wrappers
    func fetch<Q: GraphQLQuery>(
        _ query: Q,
        cachePolicy: CachePolicy = .returnCacheDataElseFetch
    ) async throws -> GraphQLResult<Q.Data> {
        try await withCheckedThrowingContinuation { cont in
            _ = client.fetch(
                query: query,
                cachePolicy: cachePolicy,
                context: nil,
                queue: .main
            ) { result in
                switch result {
                case .success(let r): cont.resume(returning: r)
                case .failure(let e): cont.resume(throwing: e)
                }
            }
        }
    }

    func perform<M: GraphQLMutation>(
        _ mutation: M
    ) async throws -> GraphQLResult<M.Data> {
        try await withCheckedThrowingContinuation { cont in
            _ = client.perform(
                mutation: mutation,
                publishResultToStore: true,
                context: nil,
                queue: .main
            ) { result in
                switch result {
                case .success(let r): cont.resume(returning: r)
                case .failure(let e): cont.resume(throwing: e)
                }
            }
        }
    }
}
