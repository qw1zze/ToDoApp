import XCTest
@testable import ToDoApp

//Тесты только для проверки запросов из сети
final class NetworkingServiceTests: XCTestCase {

    func testGetListWithToken() async {
        var network = DefaultNetworkingService()
        do {
            var response = try await network.getList()
            // swiftlint:disable:next no_direct_standard_out_logs
            Swift.print(response)
        } catch {
            // swiftlint:disable:next no_direct_standard_out_logs
            Swift.print(error.localizedDescription)
        }
        
    }
    
    func testaddTask() async {
        var network = DefaultNetworkingService()
        do {
            var response = try await network.addTask(by: TodoItemResponse(element: TodoItemCodable(from: TodoItem(text: "blablabla", priority: .high, completed: true, created: Date.now))), revision: 23)
            // swiftlint:disable:next no_direct_standard_out_logs
            Swift.print(response)
        } catch {
            // swiftlint:disable:next no_direct_standard_out_logs
            Swift.print((error as! RequestProcessorError))
            switch (error as! RequestProcessorError) {
            case .failedResponse(let response):
                // swiftlint:disable:next no_direct_standard_out_logs
                Swift.print(response.statusCode)
            default:
                break
            }
        }
    }
    
    func testGetTask() async {
        var network = DefaultNetworkingService()
        do {
            var response = try await network.getTask(by: "s5")
            // swiftlint:disable:next no_direct_standard_out_logs
            Swift.print(response)
        } catch {
            // swiftlint:disable:next no_direct_standard_out_logs
            Swift.print(error.localizedDescription)
        }
    }
    
    func testDeleteTask() async {
        var network = DefaultNetworkingService()
        do {
            var response = try await network.deleteTask(by: "s52", revision: 18)
            // swiftlint:disable:next no_direct_standard_out_logs
            Swift.print(response)
        } catch {
            // swiftlint:disable:next no_direct_standard_out_logs
            Swift.print(error.localizedDescription)
        }
    }
    
    func testChangeTask() async {
        var network = DefaultNetworkingService()
        do {
            var response = try await network.changeTask(by: TodoItemResponse(element: TodoItemCodable(from: TodoItem(id: "s5s2", text: "fonk", priority: .high, completed: true, created: Date.now))), revision: 19)
            // swiftlint:disable:next no_direct_standard_out_logs
            Swift.print(response)
        } catch {
            // swiftlint:disable:next no_direct_standard_out_logs
            Swift.print((error as! RequestProcessorError))
            switch (error as! RequestProcessorError) {
            case .failedResponse(let response):
                // swiftlint:disable:next no_direct_standard_out_logs
                Swift.print(response.statusCode)
            default:
                break
            }
        }
    }
    
    func testUpdateList() async {
        var network = DefaultNetworkingService()
        do {
            var response = try await network.updateList(by: TodoListResponse(list: [TodoItemCodable(from: TodoItem(id: "s5s2", text: "fonk", priority: .high, completed: true, created: Date.now))]), revision: 19)
            // swiftlint:disable:next no_direct_standard_out_logs
            Swift.print(response)
        } catch {
            // swiftlint:disable:next no_direct_standard_out_logs
            Swift.print((error as! RequestProcessorError))
            switch (error as! RequestProcessorError) {
            case .failedResponse(let response):
                // swiftlint:disable:next no_direct_standard_out_logs
                Swift.print(response.statusCode)
            default:
                break
            }
        }
    }
    
    func testUpdateListWhenEmpty() async {
        var network = DefaultNetworkingService()
        do {
            var response = try await network.updateList(by: TodoListResponse(list: []), revision: 19)
            // swiftlint:disable:next no_direct_standard_out_logs
            Swift.print(response)
        } catch {
            // swiftlint:disable:next no_direct_standard_out_logs
            Swift.print((error as! RequestProcessorError))
            switch (error as! RequestProcessorError) {
            case .failedResponse(let response):
                // swiftlint:disable:next no_direct_standard_out_logs
                Swift.print(response.statusCode)
            default:
                break
            }
        }
    }
}
