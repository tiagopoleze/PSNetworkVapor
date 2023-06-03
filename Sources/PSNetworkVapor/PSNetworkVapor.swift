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

extension RoutesBuilder {
    @discardableResult
    func endpoint<T: PSRequest>(
        _ endpoint: T.Type,
        use closure: @escaping (Request, T.BodyParameter) async throws -> T.ResponseModel
    ) -> Route where T.ResponseModel: AsyncResponseEncodable
    {
        return self.on(endpoint.method.nio, endpoint.path.pathComponent) { request async throws -> T.ResponseModel in
            let content = try request.content.decode(endpoint.BodyParameter)
            return try await closure(request, content)
        }
    }
}

private extension Array where Element == String {
    var pathComponent: [PathComponent] {
        map { PathComponent(stringLiteral: $0) }
    }
}

public protocol Endpoint {
    static func register(with routes: RoutesBuilder)
}
