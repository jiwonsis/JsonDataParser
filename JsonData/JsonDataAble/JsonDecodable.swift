import Foundation

enum JSONDecodeError: Error {
    case invalidData
    case keyNotFound(String)
    case keyPathNotFound(String)
}

protocol JSONDecodable {
    
    init(decoder: JSONDecode) throws
    
}

public struct JSONDecode {
    
    typealias JSON = [String: AnyObject]
    
    // MARK: - Properties
    
    private let JSONData: JSON
    
    
    // MARK: - Initialization
    
    public init(data: Data) throws {
        guard let JSONData = try JSONSerialization.jsonObject(with: data, options: []) as? JSON else {
            throw JSONDecodeError.invalidData
        }
        
        self.JSONData = JSONData
    }
    
    private init(JSONData: JSON) {
        self.JSONData = JSONData
    }
    
}

// Single Values
extension JSONDecode {
    
    // MARK: - Static Methods
    func decode<T: JSONDecodable>(data: Data) throws -> T {
        let decoder = try JSONDecode(data: data)
        return try T(decoder: decoder)
    }
    
    func decode<T>(key: String) throws -> T {
        if key.contains(".") {
            return try value(keyPath: key)
        }
        
        guard let value : T = try? value(key: key) else { throw JSONDecodeError.keyNotFound(key) }
        return value
    }
    
    private func value<T>(key: String) throws -> T {
        guard let value = JSONData[key] as? T else { throw JSONDecodeError.keyNotFound(key) }
        return value
    }
    
    private func value<T>(keyPath: String) throws -> T {
        var partial = JSONData
        let keys = keyPath.components(separatedBy: ".")
        
        for i in 0..<keys.count {
            if i < keys.count - 1 {
                if let partialJSONData = JSONData[keys[i]] as? JSON {
                    partial = partialJSONData
                } else {
                    throw JSONDecodeError.invalidData
                }
                
            } else {
                return try JSONDecode(JSONData: partial).value(key: keys[i])
            }
        }
        
        throw JSONDecodeError.keyPathNotFound(keyPath)
    }
}

// Array values
extension JSONDecode {
    
    func decode<T: JSONDecodable>(key: String) throws -> [T] {
        if key.contains(".") {
            return try value(keyPath: key)
        }
        
        guard let value: [T] = try? value(key: key) else { throw JSONDecodeError.keyNotFound(key) }
        return value
    }
    
    func value<T: JSONDecodable>(key: String) throws -> [T] {
        guard let value = JSONData[key] as? [JSON] else { throw JSONDecodeError.keyNotFound(key) }
        
        return try value.map({ partial -> T in
            let decoder = JSONDecode(JSONData: partial)
            return try T(decoder: decoder)
        })
    }
    
    func value<T: JSONDecodable>(keyPath: String) throws -> [T] {
        var partial = JSONData
        let keys = keyPath.components(separatedBy: ".")
        
        for i in 0..<keys.count {
            if i < keys.count - 1 {
                
                if let partialJSONData = JSONData[keys[i]] as? JSON {
                    partial = partialJSONData
                } else {
                    throw JSONDecodeError.invalidData
                }
                
            } else {
                return try JSONDecode(JSONData: partial).value(key: keys[i])
            }
        }
        
        throw JSONDecodeError.keyPathNotFound(keyPath)
    }
}
