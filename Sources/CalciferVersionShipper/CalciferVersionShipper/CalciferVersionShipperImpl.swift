import Foundation
import ZIPFoundation
import CalciferConfig
import Toolkit

final class CalciferVersionShipperImpl: CalciferVersionShipper {
    
    private let fileManager: FileManager
    private let session: URLSession
    
    init(
        session: URLSession,
        fileManager: FileManager)
    {
        self.session = session
        self.fileManager = fileManager
    }
    
    func shipCalcifer(
        at binaryPath: String,
        config: CalciferShipConfig,
        completion: @escaping (Result<Void, Error>) -> ())
    {
        let versionFileURL = fileManager.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("json")
        let sum = catchError { try checksum(for: binaryPath) }
        let version = CalciferVersion(checksum: sum)
        catchError { try version.save(to: versionFileURL.path) }
        upload(
            file: versionFileURL,
            url: config.versionFileURL,
            basicAccessAuthentication: config.basicAccessAuthentication) { [self] result in
                self.processUploadCompletion(
                    result,
                    onSuccess: { [self] in
                        let zipBinaryURL = self.fileManager.temporaryDirectory
                            .appendingPathComponent(UUID().uuidString)
                            .appendingPathExtension("zip")
                        catchError {
                            try self.fileManager.zipItem(at: URL(fileURLWithPath: binaryPath), to: zipBinaryURL)
                        }
                        self.upload(
                            file: zipBinaryURL,
                            url: config.zipBinaryFileURL,
                            basicAccessAuthentication: config.basicAccessAuthentication,
                            completion: { result in
                                self.processUploadCompletion(
                                    result,
                                    onSuccess: { completion(.success(())) },
                                    onFailure: { error in
                                        completion(.failure(error))
                                    }
                                )
                            }
                        )
                    },
                    onFailure: { error in
                        completion(.failure(error))
                    }
                )
        }
    }
    
    private func processUploadCompletion(
        _ result: Result<Void, Error>,
        onSuccess: () -> (),
        onFailure: (Error) -> ())
    {
        switch result {
        case .success:
            onSuccess()
        case let .failure(error):
            onFailure(error)
        }
    }
    
    private func upload(
        file: URL,
        url: URL,
        basicAccessAuthentication: String?,
        completion: @escaping (Result<Void, Error>) -> ())
    {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        if let base64CredationData = basicAccessAuthentication?.data(using: .utf8) {
            request.setValue(
                "Basic \(base64CredationData.base64EncodedString())",
                forHTTPHeaderField: "Authorization"
            )
        }
        session.uploadTask(with: request, fromFile: file) { (_, response, error) in
            if let error = error  {
                completion(.failure(error))
            } else {
                let result: Result<Void, Error> = .success(())
                completion(result)
            }
        }.resume()
    }
    
    private func checksum(for path: String) throws -> String {
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
        return data.md5()
    }
}
