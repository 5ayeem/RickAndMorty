//
//  HTTPRequest.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 23/09/2025.
//

import Foundation

public enum HTTPMethod: String {
    case GET, POST, PUT, PATCH, DELETE
}

public enum HTTPError: Error {
    case failed(message: String)
}

public struct HTTPRequest {
    var path: String
    var method: HTTPMethod = .GET
    var headers: [String: String] = [:]
    var queryItems: [URLQueryItem] = []
    var body: Data? = nil
}

public struct HTTPResponse {
    let statusCode: Int
    let data: Data
    let headers: [AnyHashable: Any]
}

public protocol HTTPClient {
    func send(_ req: HTTPRequest) async throws -> HTTPResponse
    func sendJSON<Body: Encodable, Out: Decodable>(
        path: String,
        method: HTTPMethod,
        headers: [String: String],
        body: Body
    ) async throws -> Out
}

public final class URLSessionHTTPClient: HTTPClient {
    
    private let baseURL: URL
    private let session: URLSession
    private let defaultHeaders: [String: String]
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder

    public init(
        baseURL: URL,
        session: URLSession = .shared,
        defaultHeaders: [String: String] = [:],
        jsonEncoder: JSONEncoder = .init(),
        jsonDecoder: JSONDecoder = .init()
    ) {
        self.baseURL = baseURL
        self.session = session
        self.defaultHeaders = defaultHeaders
        self.jsonEncoder = jsonEncoder
        self.jsonDecoder = jsonDecoder
    }

    public func send(_ req: HTTPRequest) async throws -> HTTPResponse {
        var comps = URLComponents(url: baseURL.appendingPathComponent(req.path), resolvingAgainstBaseURL: false)!
        if !req.queryItems.isEmpty { comps.queryItems = req.queryItems }

        var urlRequest = URLRequest(url: comps.url!)
        urlRequest.httpMethod = req.method.rawValue
        defaultHeaders.merging(req.headers, uniquingKeysWith: { _, rhs in rhs })
            .forEach { urlRequest.addValue($1, forHTTPHeaderField: $0) }
        urlRequest.httpBody = req.body

        let (data, resp) = try await session.data(for: urlRequest)
        guard let http = resp as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        return HTTPResponse(statusCode: http.statusCode, data: data, headers: http.allHeaderFields)
    }
    
    public func sendJSON<Body: Encodable, Out: Decodable>(
        path: String,
        method: HTTPMethod = .POST,
        headers: [String: String] = [:],
        body: Body
    ) async throws -> Out {
        let data = try jsonEncoder.encode(body)
        let res = try await send(.init(
            path: path,
            method: method,
            headers: ["Content-Type": "application/json"].merging(headers, uniquingKeysWith: { _, rhs in rhs }),
            body: data
        ))
        guard (200..<300).contains(res.statusCode) else {
            let snippet = String(data: res.data, encoding: .utf8) ?? ""
            throw HTTPError.failed(message: snippet)
        }
        return try jsonDecoder.decode(Out.self, from: res.data)
    }
}
