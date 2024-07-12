import Foundation

extension URLSession {
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        var sessionDataTask: URLSessionDataTask?

        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                sessionDataTask = dataTask(with: urlRequest, completionHandler: { data, response, error in
                    if Task.isCancelled {
                        continuation.resume(throwing: CancellationError())
                        return
                    }

                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }

                    guard let data = data, let response = response else {
                        continuation.resume(throwing: URLError(.unknown))
                        return
                    }

                    continuation.resume(returning: (data, response))
                    return
                })

                if Task.isCancelled {
                    continuation.resume(throwing: CancellationError())
                    return
                }

                sessionDataTask?.resume()
            }
        } onCancel: { [weak sessionDataTask] in
            sessionDataTask?.cancel()
        }
    }
}
