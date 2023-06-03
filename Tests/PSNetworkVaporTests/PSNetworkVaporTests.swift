import XCTest
import PSNetwork
import Vapor
@testable import PSNetworkVapor

final class PSNetworkVaporTests: XCTestCase {
    let app = Vapor.Application()
    func testExample() throws {
        let request = RegresRequest()
        let route = request.register(with: app) { request, _ in
                .init(
                    data: .init(
                        id: 123,
                        email: "tiago.ferreira@poleze.software",
                        firstName: "Tiago",
                        lastName: "Ferreira",
                        avatar: "iphone"
                    ),
                    support: .init(
                        url: "poleze.software",
                        text: "Hi"
                    )
                )
        }

        XCTAssertEqual(route.method, .GET)
        XCTAssertEqual(route.path.count, 3)
    }
}

struct RegresModel: Codable, Hashable {
    let data: RegresModel.Data
    let support: RegresModel.Support

    struct Data: Codable, Hashable {
        let id: Int
        let email: String
        let firstName: String
        let lastName: String
        let avatar: String
    }
    struct Support: Codable, Hashable {
        let url: String
        let text: String
    }
}

extension RegresModel: Content { }

struct RegresRequest: PSRequest {
    typealias ResponseModel = RegresModel
    var authorizationType: PSNetwork.AuthorizationType = .none
    var host: String = "reqres.in"
    var path: [String] = ["api", "users", "2"]
    var method: PSNetwork.Method<EmptyBodyParameter> = .get
}
