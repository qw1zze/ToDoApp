import Foundation

var isDirty = false
var revision = 0

protocol NetworkingService {
    func getList() async throws -> TodoListResponse
    
    func addTask(by item: TodoItemResponse, revision: Int) async throws -> TodoItemResponse
    
    func getTask(by id: String) async throws -> TodoItemResponse
    
    func deleteTask(by id: String, revision: Int) async throws -> TodoItemResponse
    
    func changeTask(by item: TodoItemResponse, revision: Int) async throws -> TodoItemResponse
    
    func updateList(by list: TodoListResponse, revision: Int) async throws -> TodoListResponse
}
