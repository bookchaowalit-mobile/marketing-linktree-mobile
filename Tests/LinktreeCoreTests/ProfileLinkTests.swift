import XCTest
@testable import LinktreeCore

final class ProfileLinkTests: XCTestCase {
    private let url = URL(string: "https://sale.example")!

    func testScheduleWindow() {
        let start = Date(timeIntervalSince1970: 100)
        let end = Date(timeIntervalSince1970: 200)
        let link = ProfileLink(title: "Sale", url: url, visibleFrom: start, visibleUntil: end)
        XCTAssertFalse(link.isVisible(at: Date(timeIntervalSince1970: 99)))
        XCTAssertTrue(link.isVisible(at: start))
        XCTAssertFalse(link.isVisible(at: end))
    }

    func testOpenEndedWindows() {
        let t = Date(timeIntervalSince1970: 1_000)
        XCTAssertTrue(ProfileLink(title: "Always", url: url).isVisible(at: t))
        let fromOnly = ProfileLink(title: "Launch", url: url, visibleFrom: t)
        XCTAssertFalse(fromOnly.isVisible(at: t.addingTimeInterval(-1)))
        XCTAssertTrue(fromOnly.isVisible(at: t.addingTimeInterval(1_000_000)))
        let untilOnly = ProfileLink(title: "Ends", url: url, visibleUntil: t)
        XCTAssertTrue(untilOnly.isVisible(at: .distantPast))
        XCTAssertFalse(untilOnly.isVisible(at: t))
    }

    func testDisabledLinkIsHiddenEvenInsideItsWindow() {
        var link = ProfileLink(title: "Sale", url: url,
                               visibleFrom: Date(timeIntervalSince1970: 0),
                               visibleUntil: Date(timeIntervalSince1970: 100))
        link.enabled = false
        XCTAssertFalse(link.isVisible(at: Date(timeIntervalSince1970: 50)))
    }

    func testNewLinkStartsEnabledWithNoClicks() {
        let link = ProfileLink(title: "Shop", url: url)
        XCTAssertTrue(link.enabled)
        XCTAssertEqual(link.clicks, 0)
        XCTAssertNotEqual(link.id, ProfileLink(title: "Shop", url: url).id)
    }
}
