import Byte
import RFC_768
import RFC_791
import Testing

@Suite
struct `README Tests` {

    @Test
    func `Quick Start`() throws {
        let datagram = try RFC_768.Datagram(
            source: .init(12345),
            destination: .dns,
            data: [Byte](repeating: Byte(bitPattern: 0), count: 4)
        )

        #expect(datagram.header.length.rawValue == 12)
        #expect(datagram.header.length.data == 4)
        #expect(datagram.header.checksum.isAbsent)

        let pseudoHeader = RFC_768.PseudoHeader(
            source: try .init("192.168.1.1"),
            destination: try .init("192.168.1.2"),
            length: datagram.header.length.rawValue
        )

        #expect(pseudoHeader.length == 12)
        #expect(RFC_768.protocolNumber == .udp)
    }

    @Test
    func `Ports`() {
        #expect(RFC_768.Port.dns.rawValue == 53)
        #expect(RFC_768.Port(8080).isRegistered)
        #expect(RFC_768.Port(50000).isDynamic)
    }

    @Test
    func `Length`() throws {
        #expect(try RFC_768.Length(20).data == 12)
        #expect(throws: RFC_768.Length.Error.tooShort(7)) {
            try RFC_768.Length(7)
        }
    }
}
