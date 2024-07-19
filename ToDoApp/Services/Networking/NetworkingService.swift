import Foundation

protocol NetworkingService {
    func getList(completion: @escaping (Result<TodoListResponse, Error>) -> Void) async 
    
    func addTask(by item: TodoItemResponse, revision: Int, completion: @escaping (Result<TodoItemResponse, Error>) -> Void) async
}
