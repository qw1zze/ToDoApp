import Foundation

extension DefaultNetworkingService: NetworkingService {
    func getList(completion: @escaping (Result<TodoListResponse, Error>) -> Void) async {
        do {
            let response: TodoListResponse = try await sendRequest(
                request: NetworkRequest(
                    baseUrl: NetworkConstants.baseUrl,
                    path: NetworkConstants.Paths.todoList,
                    headers: [NetworkConstants.Headers.authorization: NetworkConstants.token]
                ))
            completion(.success(response))
        } catch {
            completion(.failure(error))
        }
    }
    
    func addTask(by item: TodoItemResponse, revision: Int, completion: @escaping (Result<TodoItemResponse, Error>) -> Void) async {
            do {
                let body = try JSONEncoder().encode(item)
                let response: TodoItemResponse = try await sendRequest(request: NetworkRequest(
                    baseUrl: NetworkConstants.baseUrl,
                    path: NetworkConstants.Paths.todoList,
                    headers: [NetworkConstants.Headers.authorization: NetworkConstants.token,
                              NetworkConstants.Headers.lastRevision: String(revision)],
                    body: body,
                    method: .post))
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
    }
}
