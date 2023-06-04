import PSNetwork
import Vapor

public extension RoutesBuilder {
    @discardableResult
    func endpoint<T: PSRequest>(
        _ endpoint: T.Type,
        use closure: @escaping (Vapor.Request, T.BodyParameter?) async throws -> T.ResponseModel
    ) -> Vapor.Route where T.ResponseModel: Vapor.AsyncResponseEncodable
    {
        return self.on(endpoint.method.nio, endpoint.path.pathComponent) { request async throws -> T.ResponseModel in
            if let content = try? request.content.decode(endpoint.BodyParameter) {
                return try await closure(request, content)
            }
            return try await closure(request, nil)
        }
    }
}
