import XCTest
@testable import GoogleUrlData

final class GoogleUrlDataTests: XCTestCase {
    
    let urlString = "https://www.google.com/maps/place/%D0%94%D0%B2%D0%BE%D1%80%D0%B5%D1%86+%D0%9D%D0%B8%D0%BC%D1%84%D0%B5%D0%BD%D0%B1%D1%83%D1%80%D0%B3/@48.1582638,11.5022729,3a,75y,359.89h,103.4t/data=!3m8!1e1!3m6!1sAF1QipOTx0xByeh0K1BiHeYeObGPZlsZQ2MCeiLrt9EE!2e10!3e11!6shttps:%2F%2Flh5.googleusercontent.com%2Fp%2FAF1QipOTx0xByeh0K1BiHeYeObGPZlsZQ2MCeiLrt9EE%3Dw203-h100-k-no-pi-13.395872-ya0.88743275-ro-0-fo100!7i8704!8i4352!4m7!3m6!1s0x479e77cc7fa2682d:0x274c5616a51e6d66!8m2!3d48.1582675!4d11.5033143!14m1!1BCgIgARICCAI"

    func testWebData() throws {
        _ = try urlData()
    }

    func testWebDataNegative() throws {
        let url = URL(string: "https://developer.apple.com")
        let webData = GoogleUrlData(url: url!)
        XCTAssert(webData.rows.isEmpty)
    }
    
    func testWebDataRowNegative() throws {
        let webData = try urlData()
        let row = webData.urlDataRow(forPath: "3.2")
        XCTAssertNil(row)
    }

    func testWebDataRowInt() throws {
        let webData = try urlData()
        let row = webData.urlDataRow(forPath: "3.3.7")
        XCTAssertNotNil(row)
        if let row = row {
            XCTAssertEqual(row.key, GoogleUrlDataRow.Key.integer)
            XCTAssertEqual(row.value, "8704")
        }
    }
    
    func testWebDataRowDouble() throws {
        let webData = try urlData()
        let row = webData.urlDataRow(forPath: "4.3.8.3")
        XCTAssertNotNil(row)
        if let row = row {
            XCTAssertEqual(row.key, GoogleUrlDataRow.Key.double)
            XCTAssertEqual(row.value, "48.1582675")
        }
    }

    func testWebDataPanoramaId() throws {
        let webData = try urlData()
        let panoramaId = webData.panoramaId
        XCTAssertNotNil(panoramaId)
        if let panoramaId = panoramaId {
            XCTAssertEqual(panoramaId, "AF1QipOTx0xByeh0K1BiHeYeObGPZlsZQ2MCeiLrt9EE")
        }
    }

    func testWebDataUserContent() throws {
        let webData = try urlData()
        let content = webData.userContent
        XCTAssertNotNil(content)
        if let content = content {
             XCTAssertEqual(content, "https://lh5.googleusercontent.com/p/AF1QipOTx0xByeh0K1BiHeYeObGPZlsZQ2MCeiLrt9EE=w203-h100-k-no-pi-13.395872-ya0.88743275-ro-0-fo100")
        }
    }
    
    func testWebDataUserContentSize() throws {
        let webData = try urlData()
        let size = webData.userContentSize
        XCTAssertNotNil(size)
        if let size = size {
            XCTAssertEqual(size.0, 8704)
            XCTAssertEqual(size.1, 4352)
        }
    }
    
    func testWebDataCoordinates() throws {
        let webData = try urlData()
        let lat_lng = webData.coordinates
        XCTAssertNotNil(lat_lng)
        if let lat_lng = lat_lng {
            XCTAssertEqual(lat_lng.0, 48.1582675)
            XCTAssertEqual(lat_lng.1, 11.5033143)
        }
    }

    private func urlData() throws -> GoogleUrlData {
        let url = URL(string: urlString)
        XCTAssertNotNil(url)
        let webData = GoogleUrlData(url: url!)
        XCTAssertTrue(webData.rows.count > 0)
        return webData
    }
}
