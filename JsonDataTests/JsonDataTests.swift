import XCTest
@testable import JsonData

class JsonDataTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func makeMockup() -> [String: AnyObject]? {
        // 번들 URL 지정
        let url = URL(string: "https://api.darksky.net/forecast/00f4f114d381cbb3f90b86a9dd212a2d/37.8267,-122.423")!
        
        // data 타입으로 로드
        let data = try! Data(contentsOf: url)
        
        // JSON Unserialize
        return try! JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
    }
    
    func test_makeMockup_shouldNotNil() {
        XCTAssertNotNil(makeMockup())
    }
    
    func test_quickAndDirty_shouldNotNil() {
        
        let weatherDatas = JsonParseMockup.quickAndDirty(JSON: makeMockup())
        
        XCTAssertNotNil(weatherDatas)
    }
    
    func test_refectoringStruct_shouldNotNil() {
        let weatherData = WeatherData(JSON: makeMockup() as Any)
        
        XCTAssertNotNil(weatherData)
    }

    
    
}
