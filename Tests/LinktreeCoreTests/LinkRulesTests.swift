import XCTest
@testable import LinktreeCore

final class LinkRulesTests: XCTestCase {
    // MARK: handles

    func testHandleRules() throws {
        XCTAssertEqual(try LinkRules.normalizeHandle(" @Book.Chaowalit "), "book.chaowalit")
        for bad in ["ab", ".book", "book.", "bo..ok", "book!", String(repeating: "a", count: 31), "bo@ok"] {
            XCTAssertThrowsError(try LinkRules.normalizeHandle(bad), bad)
        }
    }

    func testHandleLengthBoundsAndAllowedCharacters() throws {
        XCTAssertEqual(try LinkRules.normalizeHandle("abc"), "abc")
        let thirty = String(repeating: "a", count: 30)
        XCTAssertEqual(try LinkRules.normalizeHandle(thirty), thirty)
        XCTAssertEqual(try LinkRules.normalizeHandle("My_Shop.2026"), "my_shop.2026")
        XCTAssertThrowsError(try LinkRules.normalizeHandle("my shop")) {
            XCTAssertEqual($0 as? ProfileError, .invalidHandle("my shop"))
        }
        XCTAssertThrowsError(try LinkRules.normalizeHandle("my-shop"))
    }

    // MARK: URLs

    func testURLRules() throws {
        XCTAssertEqual(try LinkRules.parseURL("bookchaowalit.com").absoluteString, "https://bookchaowalit.com")
        XCTAssertEqual(try LinkRules.parseURL("mailto:hi@example.com").scheme, "mailto")
        XCTAssertEqual(try LinkRules.parseURL("tel:+66812345678").scheme, "tel")
        for bad in ["http://insecure.example", "javascript:alert(1)", "localhost", "https://", "  "] {
            XCTAssertThrowsError(try LinkRules.parseURL(bad), bad)
        }
    }

    func testURLSchemeIsCaseInsensitiveAndInputIsTrimmed() throws {
        XCTAssertEqual(try LinkRules.parseURL("HTTPS://Example.com/shop").scheme?.lowercased(), "https")
        XCTAssertEqual(try LinkRules.parseURL("  shop.example/p/1 \n").absoluteString, "https://shop.example/p/1")
    }

    func testOtherSchemesAreRejected() {
        for bad in ["ftp://files.example", "data:text/html,hi", "file:///etc/hosts", "JavaScript:alert(1)"] {
            XCTAssertThrowsError(try LinkRules.parseURL(bad), bad) {
                XCTAssertEqual($0 as? ProfileError, .invalidURL(bad))
            }
        }
    }

    // MARK: UTM

    func testUTMIsAddedOnceAndOnlyToHttps() throws {
        let url = try LinkRules.parseURL("https://shop.example/p?id=7&utm_source=ig")
        let tagged = LinkRules.withUTM(url, source: "linktree")
        let items = URLComponents(url: tagged, resolvingAgainstBaseURL: false)?.queryItems ?? []
        XCTAssertEqual(items.map(\.name), ["id", "utm_source", "utm_medium"])
        XCTAssertEqual(items.first { $0.name == "utm_source" }?.value, "ig")
        let mail = try LinkRules.parseURL("mailto:a@b.co")
        XCTAssertEqual(LinkRules.withUTM(mail, source: "x"), mail)
    }

    func testUTMOnPlainURLUsesGivenSourceAndMedium() throws {
        let url = try LinkRules.parseURL("shop.example")
        let tagged = LinkRules.withUTM(url, source: "bio", medium: "profile")
        let items = URLComponents(url: tagged, resolvingAgainstBaseURL: false)?.queryItems ?? []
        XCTAssertEqual(items, [URLQueryItem(name: "utm_source", value: "bio"), URLQueryItem(name: "utm_medium", value: "profile")])
        XCTAssertEqual(LinkRules.withUTM(tagged, source: "other"), tagged, "tagging twice changes nothing")
    }
}
