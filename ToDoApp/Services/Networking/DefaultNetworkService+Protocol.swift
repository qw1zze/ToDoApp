import Foundation

extension DefaultNetworkingService: NetworkingService {
    func getList() async throws -> TodoListResponse {
        let response: TodoListResponse = try await sendRequest(
            request: NetworkRequest(
            baseUrl: NetworkConstants.baseUrl,
            path: NetworkConstants.Paths.todoList,
            headers: [NetworkConstants.Headers.authorization: NetworkConstants.token],
            method: .get))
        return response
    }
    
    func addTask(by item: TodoItemResponse, revision: Int) async throws -> TodoItemResponse {
            let body = try JSONEncoder().encode(item)
            let response: TodoItemResponse = try await sendRequest(request: NetworkRequest(
                baseUrl: NetworkConstants.baseUrl,
                path: NetworkConstants.Paths.todoList,
                headers: [NetworkConstants.Headers.authorization: NetworkConstants.token,
                          NetworkConstants.Headers.lastRevision: String(revision)],
                body: body,
                method: .post))
        
            return response
    }
    
    func getTask(by id: String) async throws -> TodoItemResponse {
        let response: TodoItemResponse = try await sendRequest(
            request: NetworkRequest(
            baseUrl: NetworkConstants.baseUrl,
            path: NetworkConstants.Paths.todoList + "/\(id)",
            headers: [NetworkConstants.Headers.authorization: NetworkConstants.token]))
        return response
    }
    
    func deleteTask(by id: String, revision: Int) async throws -> TodoItemResponse {
        let response: TodoItemResponse = try await sendRequest(request: NetworkRequest(
            baseUrl: NetworkConstants.baseUrl,
            path: NetworkConstants.Paths.todoList + "/\(id)",
            headers: [NetworkConstants.Headers.authorization: NetworkConstants.token,
                      NetworkConstants.Headers.lastRevision: String(revision)],
            method: .delete))
        return response
    }
    
    func changeTask(by item: TodoItemResponse, revision: Int) async throws -> TodoItemResponse {
        let body = try JSONEncoder().encode(item)
        let response: TodoItemResponse = try await sendRequest(request: NetworkRequest(
            baseUrl: NetworkConstants.baseUrl,
            path: NetworkConstants.Paths.todoList + "/\(item.element.id)",
            headers: [NetworkConstants.Headers.authorization: NetworkConstants.token,
                      NetworkConstants.Headers.lastRevision: String(revision)],
            body: body,
            method: .put))
        return response
    }
    
    func updateList(by list: TodoListResponse, revision: Int) async throws -> TodoListResponse {
        let body = try JSONEncoder().encode(list)
        let response: TodoListResponse = try await sendRequest(request: NetworkRequest(
            baseUrl: NetworkConstants.baseUrl,
            path: NetworkConstants.Paths.todoList,
            headers: [NetworkConstants.Headers.authorization: NetworkConstants.token,
                      NetworkConstants.Headers.lastRevision: String(revision)],
            body: body,
            method: .patch))
        return response
    }
}
