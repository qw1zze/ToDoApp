@testable import ToDoApp
import XCTest

private struct Info: Codable {
    let count: Int
    let name: String
    let age: Int
}

final class URLSessionTests: XCTestCase {

    private var url = URL(string: "https://api.agify.io/?name=Dmitriy")!

    func testRequest() async throws {
        let request = URLRequest(url: url)
        
        do {
            let (data, response) = try await URLSession.shared.dataTask(for: request)
            XCTAssertNotNil(data)
            XCTAssertNotNil(response)

            let joke = try JSONDecoder().decode(Info.self, from: data)
            XCTAssertNotNil(joke)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testCancelRequest() async throws {
        let expect = expectation(description: "is cancelled")
        let request = URLRequest(url: url)

        let task = Task {
            do {
                let (data, response) = try await URLSession.shared.dataTask(for: request)
                XCTFail("Cancelletion error")
            } catch is CancellationError {
                expect.fulfill()
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
        task.cancel()
        await fulfillment(of: [expect], timeout: 5)
    }
}
