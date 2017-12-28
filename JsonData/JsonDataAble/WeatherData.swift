import Foundation

struct WeatherData {
    public let lat: Double
    public let long: Double
    
    public let hourData: [WeatherHourData]
    
    public init(lat: Double, long: Double, hourData: [WeatherHourData]) {
        self.lat = lat
        self.long = long
        self.hourData = hourData
    }
}

extension WeatherData {
    public init?(JSON: Any?) {
        guard let JSON = JSON as? [String: AnyObject]  else { return nil }
        
        guard let lat = JSON["latitude"] as? Double else { return nil }
        guard let long = JSON["longitude"] as? Double else { return nil }
        guard let hourlyData = JSON["hourly"]?["data"] as? [[String: AnyObject]] else { return nil }
        
        self.lat = lat
        self.long = long
        
        var buffer = [WeatherHourData]()
        
        for hourlyDataPoint in hourlyData {
            if let weatherHourData = WeatherHourData(JSON: hourlyDataPoint) {
                buffer.append(weatherHourData)
            }
        }
        
        self.hourData = buffer
    }
}

extension WeatherData: JSONDecodable {
    init(decoder: JSONDecode) throws {
        self.lat = try decoder.decode(key: "latitude")
        self.long = try decoder.decode(key: "longitude")
        self.hourData = try decoder.decode(key: "hourly.data")
    }
}
