import XCTest
@testable import JsonData


class JsonDecodableTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func makeMockupData() -> Data? {
        // 번들 URL 지정
        let url = URL(string: "https://api.darksky.net/forecast/00f4f114d381cbb3f90b86a9dd212a2d/37.8267,-122.423")!
        
        
        // data 타입으로 로드
        return try? Data(contentsOf: url)
    }
    
    func test_makeMockupData_shouldNotNil() {
        XCTAssertNotNil(makeMockupData())
    }
    
    func test_JSONDecode_shoudThrowsNotError() {

        guard let data = makeMockupData() else {
            XCTFail("Data Convert fail")
            return
        }
        
        do {
            let decoder = try JSONDecode(data: data)
            let _ = try WeatherData(decoder: decoder)
        } catch {
            XCTFail("Fail: \(error)")
        }
        
    }

}
