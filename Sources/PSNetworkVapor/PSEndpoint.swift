import Vapor

public protocol PSEndpoint {
    static func register(with routes: RoutesBuilder)
}
