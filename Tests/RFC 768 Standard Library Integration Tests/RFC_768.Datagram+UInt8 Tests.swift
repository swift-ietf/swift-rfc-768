import Byte
import RFC_768
import RFC_768_Standard_Library_Integration
import Testing

@Suite
struct `RFC 768 Standard Library Integration Tests` {

    @Test
    func `a datagram accepts a UInt8 payload with an explicit header`() throws {
        let header = RFC_768.Header(
            source: .init(12345),
            destination: .dns,
            length: try .init(12),
            checksum: .zero
        )
        let payload: [UInt8] = [0x00, 0x01, 0x00, 0x00]
        let datagram = RFC_768.Datagram(header: header, data: payload)
        #expect(datagram.header == header)
        #expect(datagram.data == payload.map(Byte.init(bitPattern:)))
    }

    @Test
    func `a datagram measures a UInt8 payload`() throws {
        let payload: [UInt8] = [0xDE, 0xAD, 0xBE, 0xEF]
        let datagram = try RFC_768.Datagram(
            source: .init(8080),
            destination: .syslog,
            data: payload
        )
        #expect(datagram.header.length.rawValue == 12)
        #expect(datagram.data == payload.map(Byte.init(bitPattern:)))
    }

    @Test
    func `agrees with the Byte initializer`() throws {
        let typed = try RFC_768.Datagram(
            source: .init(8080),
            destination: .syslog,
            data: [Byte(bitPattern: 1), Byte(bitPattern: 2)]
        )
        let bridged = try RFC_768.Datagram(
            source: .init(8080),
            destination: .syslog,
            data: [1, 2] as [UInt8]
        )
        #expect(bridged == typed)
    }
}
