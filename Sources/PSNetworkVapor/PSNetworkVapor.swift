import PSNetwork
import Vapor

private extension PSNetwork.Method {
    var nio: NIOHTTP1.HTTPMethod {
        switch self {
        case .get: return .GET
        case .post: return .POST
        case .put: return .PUT
        case .patch: return .PATCH
        case .delete: return .DELETE
        }
    }
}

public extension PSRequest where ResponseModel: AsyncResponseEncodable {
    @discardableResult
    func register(
        with app: Vapor.Application,
        use closure: @escaping (Vapor.Request, BodyParameter?) async throws -> ResponseModel
    ) -> Vapor.Route {
        return app.on(method.nio, path.pathComponent) { request async throws -> ResponseModel in
            switch method {
            case .get, .delete:
                return try await closure(request, nil)
            case .patch(let content), .post(let content), .put(let content):
                return try await closure(request, content)
            }
        }
    }
}

private extension Array where Element == String {
    var pathComponent: [PathComponent] {
        map { PathComponent(stringLiteral: $0) }
    }
}
