import Foundation
import RFC_768
import RFC_768_Foundation_Integration
import Testing

@Suite
struct `RFC 768 Foundation Integration Tests` {

    @Test
    func `a port codes as its number`() throws {
        let encoded = try JSONEncoder().encode(RFC_768.Port.dns)

        #expect(String(decoding: encoded, as: UTF8.self) == "53")
        #expect(try JSONDecoder().decode(RFC_768.Port.self, from: encoded) == .dns)
    }

    @Test
    func `a checksum codes as its number`() throws {
        let checksum = RFC_768.Checksum(rawValue: 0xABCD)

        let encoded = try JSONEncoder().encode(checksum)

        #expect(try JSONDecoder().decode(RFC_768.Checksum.self, from: encoded) == checksum)
    }

    @Test
    func `a length codes as its number`() throws {
        let length = try RFC_768.Length(20)

        let encoded = try JSONEncoder().encode(length)

        #expect(String(decoding: encoded, as: UTF8.self) == "20")
        #expect(try JSONDecoder().decode(RFC_768.Length.self, from: encoded) == length)
    }

    @Test
    func `a length below the header size fails to decode`() {
        let encoded = Data("7".utf8)

        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(RFC_768.Length.self, from: encoded)
        }
    }
}
