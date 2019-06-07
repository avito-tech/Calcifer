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
        let versionFileURL = createVersionFile(
            binaryPath: binaryPath
        )
        uploadVersionFile(
            binaryPath: binaryPath,
            versionFileURL: versionFileURL,
            config: config,
            completion: completion
        )
    }
    
    private func createVersionFile(binaryPath: String) -> URL {
        let versionFileURL = fileManager.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("json")
        let sum = catchError { try checksum(for: binaryPath) }
        let version = CalciferVersion(checksum: sum)
        catchError { try version.save(to: versionFileURL.path) }
        return versionFileURL
    }
    
    private func uploadVersionFile(
        binaryPath: String,
        versionFileURL: URL,
        config: CalciferShipConfig,
        completion: @escaping (Result<Void, Error>) -> ())
    {
        upload(
            file: versionFileURL,
            url: config.versionFileURL,
            basicAccessAuthentication: config.basicAccessAuthentication) { result in
                self.processUploadCompletion(
                    result,
                    file: versionFileURL,
                    onSuccess: {
                        self.uploadBinaryFile(
                            binaryPath: binaryPath,
                            config: config,
                            completion: completion
                        )
                    },
                    onFailure: { error in
                        completion(.failure(error))
                }
            )
        }
    }
    
    private func uploadBinaryFile(
        binaryPath: String,
        config: CalciferShipConfig,
        completion: @escaping (Result<Void, Error>) -> ())
    {
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
                    file: zipBinaryURL,
                    onSuccess: { completion(.success(())) },
                    onFailure: { error in
                        completion(.failure(error))
                    }
                )
            }
        )
    }
    
    private func processUploadCompletion(
        _ result: Result<Void, Error>,
        file: URL,
        onSuccess: () -> (),
        onFailure: (Error) -> ())
    {
        catchError { try fileManager.removeItem(at: file) }
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
