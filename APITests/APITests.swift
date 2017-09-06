import XCTest
@testable import API

final class APITests: XCTestCase {

    // TODO: request dummy response 
    func testSearchPhoto() {
        let expectation = self.expectation(description: "searchPhoto")

        Photozou.searchPhoto(keyword: "watermelon") { result in
            switch result {
            case .success(let response):
                print("success count: \(response.count)")
                print("success value: \(response)")
                expectation.fulfill()
            case .failure(let error):
                print("error: \(error)")
            }
        }

        waitForExpectations(timeout: 10, handler: nil)
    }
}
