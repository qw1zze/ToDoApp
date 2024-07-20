import Foundation

var isDirty = false
var revision = 0

protocol NetworkingService {
    func getList(completion: @escaping (Result<TodoListResponse, Error>) -> Void) async 
    
    func addTask(by item: TodoItemResponse, revision: Int, completion: @escaping (Result<TodoItemResponse, Error>) -> Void) async
    
    func getTask(by id: String, completion: @escaping (Result<TodoItemResponse, Error>) -> Void) async
    
    func deleteTask(by id: String, revision: Int, completion: @escaping (Result<TodoItemResponse, Error>) -> Void) async
    
    func changeTask(by item: TodoItemResponse, revision: Int, completion: @escaping (Result<TodoItemResponse, Error>) -> Void) async
    
    func updateList(by list: TodoListResponse, revision: Int, completion: @escaping (Result<TodoListResponse, Error>) -> Void) async
}
