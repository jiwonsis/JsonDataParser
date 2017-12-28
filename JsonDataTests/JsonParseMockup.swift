import Foundation
@testable import JsonData

struct JsonParseMockup {
    // #1 Quick And Dirty
    static func quickAndDirty(JSON: [String: AnyObject]?) -> WeatherData? {
        
        guard let JSON = JSON else { return nil }
        
        guard let lat = JSON["latitude"] as? Double else { return nil }
        guard let long = JSON["longitude"] as? Double else { return nil }
        guard let hourlyData = JSON["hourly"]?["data"] as? [[String: AnyObject]] else { return nil }
        
        // Create Buffer
        var hourData = [WeatherHourData]()
        
        for hourlyDataPoint in hourlyData {
            guard let time = hourlyDataPoint["time"] as? Double else { return nil }
            guard let windSpeed = hourlyDataPoint["windSpeed"] as? Double else { return nil }
            guard let temperature = hourlyDataPoint["temperature"] as? Double else { return nil }
            guard let precipitation = hourlyDataPoint["precipIntensity"] as? Double else { return nil }
            
            // time 값을 date값으로 변환
            let timeAsDate = Date(timeIntervalSince1970: time)
            
            // WeatherHourData 생성
            let weatherHourData = WeatherHourData(time: timeAsDate, windspeed: windSpeed, temperature: temperature, precipitation: precipitation)
            
            // 버퍼에 추가
            hourData.append(weatherHourData)
        }
        
        return WeatherData(lat: lat, long: long, hourData: hourData)
    }
}
