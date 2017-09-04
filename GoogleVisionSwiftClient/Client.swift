//
//  Client.swift
//  GoogleVisionSwiftClient
//
//  Created by Ambas Chobsanti (Lazada Group) on 7/29/17.
//  Copyright © 2017 Ambas. All rights reserved.
//

public typealias SuccessHandler = (Result<[String]>) -> Void

public struct Client {

    let googleAPIKey: String
    var googleURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
    }

    public init(googleAPIKey key: String) {
        self.googleAPIKey = key
    }

    public func detectWords(fromImage image: UIImage, success: @escaping SuccessHandler) {
        let session = URLSession.shared
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")

        guard let base64Image = UIImageJPEGRepresentation(image, 1)?.base64EncodedString() else {
            return
        }
        let requestJSON = [
            "requests": [
                "image": [
                    "content": base64Image
                ],
                "features": [
                    [
                        "type": "TEXT_DETECTION",
                        "maxResults": 100
                    ]
                ]
            ]
        ]

        // Serialize the JSON
        guard let data = try? JSONSerialization.data(withJSONObject: requestJSON, options: .prettyPrinted) else {
            return
        }

        request.httpBody = data

        let task = session.dataTask(with: request) { (data, _, _) in
            guard let data = data else {
                success(.error(ExtractDataError(kind: .responseDataError)))
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                success(.error(ExtractDataError(kind: .serializationError)))
                return
            }
            guard let jsonDict = json as? [String: Any] else {
                success(.error(ExtractDataError(kind: .jsonFormatError)))
                return
            }
            guard
                let response = jsonDict["responses"] as? [Any],
                let annotationContainer = response.first as? [String: Any],
                let textAnnotations = annotationContainer["textAnnotations"] as? [[String: Any]] else {
                if let errorDetailDict = jsonDict["error"] as? [String: Any],
                    let errorDetail = errorDetailDict["message"] as? String {
                    success(.error(ExtractDataError(kind: .error(erorDetail: errorDetail))))
                } else if let _ = jsonDict["responses"] {
                    success(.error(ExtractDataError(kind: .error(erorDetail: "Cant find any word"))))
                } else {
                    success(.error(ExtractDataError(kind: .jsonFormatError)))
                }
                return
            }

            let wordDetectedResult = textAnnotations
                .map { annotation in
                    return (annotation["description"] as? String) ?? ""
                }

            success(.success(wordDetectedResult))
        }
        task.resume()
    }
}

public struct ExtractDataError: Error {

    public let kind: ErrorKind
}

public enum ErrorKind {
    case responseDataError
    case serializationError
    case jsonFormatError
    case error(errorDetail: String)
}
