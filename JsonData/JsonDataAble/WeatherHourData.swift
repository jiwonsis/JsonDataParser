import Foundation


struct WeatherHourData {
    public let time: Date
    public let windSpeed: Double
    public let temperature: Double
    public let precipitation: Double
    
    public init(time: Date, windspeed: Double, temperature: Double, precipitation: Double) {
        self.time = time
        self.windSpeed = windspeed
        self.temperature = temperature
        self.precipitation = precipitation
    }
}

extension WeatherHourData {
    public init?(JSON: Any?) {
        guard let JSON = JSON as? [String: AnyObject] else { return nil }
        
        guard let time = JSON["time"] as? Double else { return nil }
        guard let windSpeed = JSON["windSpeed"] as? Double else { return nil }
        guard let temperature = JSON["temperature"] as? Double else { return nil }
        guard let precipitation = JSON["precipIntensity"] as? Double else { return nil }
        
        self.windSpeed = windSpeed
        self.temperature = temperature
        self.precipitation = precipitation
        self.time = Date(timeIntervalSince1970: time)
    }
}

extension WeatherHourData: JSONDecodable {
    init(decoder: JSONDecode) throws {
        self.windSpeed = try decoder.decode(key: "windSpeed")
        self.temperature = try decoder.decode(key: "temperature")
        self.precipitation = try decoder.decode(key: "precipIntensity")
        
        let time: Double = try decoder.decode(key: "time")
        self.time = Date(timeIntervalSince1970: time)
        
    }
}
