import XCTest
@testable import LinktreeCore

final class ProfileTests: XCTestCase {
    func testLinksScheduleOrderAndStats() throws {
        var p = try Profile(handle: "book", displayName: "Book")
        let site = try p.addLink(title: " Website ", url: "bookchaowalit.com")
        let promo = try p.addLink(title: "Promo", url: "https://promo.example")
        XCTAssertThrowsError(try p.addLink(title: " ", url: "a.example")) { XCTAssertEqual($0 as? ProfileError, .emptyTitle) }
        XCTAssertEqual(site.title, "Website")

        try p.move(promo.id, to: 0)
        XCTAssertEqual(p.links.map(\.title), ["Promo", "Website"])

        try p.setEnabled(promo.id, false)
        let now = Date(timeIntervalSince1970: 1_000)
        XCTAssertEqual(p.visibleLinks(at: now).map(\.title), ["Website"])

        p.recordView(); p.recordView(); p.recordView(); p.recordView()
        try p.recordClick(site.id)
        XCTAssertEqual(p.clickThroughRate(site.id), 25, accuracy: 1e-9)
        XCTAssertEqual(p.clickThroughRate(UUID()), 0)
        XCTAssertThrowsError(try p.recordClick(UUID()))
    }

    func testInitNormalizesOrRejectsTheHandle() throws {
        XCTAssertEqual(try Profile(handle: "@Book", displayName: "Book").handle, "book")
        XCTAssertThrowsError(try Profile(handle: "x", displayName: "X")) {
            XCTAssertEqual($0 as? ProfileError, .invalidHandle("x"))
        }
    }

    func testAddLinkRejectsBadURLWithoutAddingIt() throws {
        var p = try Profile(handle: "book", displayName: "Book")
        XCTAssertThrowsError(try p.addLink(title: "Old site", url: "http://old.example")) {
            XCTAssertEqual($0 as? ProfileError, .invalidURL("http://old.example"))
        }
        XCTAssertTrue(p.links.isEmpty)
    }

    func testMoveClampsPositionToTheList() throws {
        var p = try Profile(handle: "book", displayName: "Book")
        let a = try p.addLink(title: "A", url: "a.example")
        _ = try p.addLink(title: "B", url: "b.example")
        let c = try p.addLink(title: "C", url: "c.example")
        try p.move(a.id, to: 99)
        XCTAssertEqual(p.links.map(\.title), ["B", "C", "A"])
        try p.move(c.id, to: -5)
        XCTAssertEqual(p.links.map(\.title), ["C", "B", "A"])
    }

    func testUnknownLinkIdsThrowLinkNotFound() throws {
        var p = try Profile(handle: "book", displayName: "Book")
        let missing = UUID()
        XCTAssertThrowsError(try p.move(missing, to: 0)) { XCTAssertEqual($0 as? ProfileError, .linkNotFound) }
        XCTAssertThrowsError(try p.setEnabled(missing, true)) { XCTAssertEqual($0 as? ProfileError, .linkNotFound) }
        XCTAssertThrowsError(try p.recordClick(missing)) { XCTAssertEqual($0 as? ProfileError, .linkNotFound) }
    }

    func testClickThroughRateIsZeroWithoutViews() throws {
        var p = try Profile(handle: "book", displayName: "Book")
        let link = try p.addLink(title: "Shop", url: "shop.example")
        try p.recordClick(link.id)
        XCTAssertEqual(p.views, 0)
        XCTAssertEqual(p.clickThroughRate(link.id), 0)
        p.recordView()
        XCTAssertEqual(p.clickThroughRate(link.id), 100, accuracy: 1e-9)
    }
}
