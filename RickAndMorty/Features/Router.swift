//
//  Router.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 24/09/2025.
//

import SwiftUI
import Combine

enum Route: Hashable, Codable {
    case charactersList
    case characterDetails(id: String)
}

@MainActor
final class Router: ObservableObject {
    
    @Published var path = NavigationPath()
    @Published var sheet: Route?
    @Published var fullScreen: Route?

    func go(_ route: Route) {
        path.append(route)
    }

    func setStack(_ routes: [Route]) {
        path = NavigationPath()
        routes.forEach {
            path.append($0)
        }
    }

    // Pops
    func back() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path = NavigationPath()
    }

    // Modals
    func present(_ route: Route) {
        sheet = route
    }
    
    func presentFull(_ route: Route) {
        fullScreen = route
    }
    
    func dismissSheet() {
        sheet = nil
    }
    
    func dismissFull() {
        fullScreen = nil
    }
}
