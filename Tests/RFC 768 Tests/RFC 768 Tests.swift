import Byte
import RFC_768
import RFC_791
import Testing

@Suite
struct `RFC 768 Tests` {
    @Suite struct `Port Tests` {}
    @Suite struct `Length Tests` {}
    @Suite struct `Checksum Tests` {}
    @Suite struct `Header Tests` {}
    @Suite struct `Pseudo Header Tests` {}
    @Suite struct `Datagram Tests` {}
    @Suite struct `Specification Tests` {}
}

func bytes(_ values: UInt8...) -> [Byte] {
    values.map(Byte.init(bitPattern:))
}

extension `RFC 768 Tests`.`Port Tests` {

    @Test
    func `a port is its sixteen-bit number`() {
        let port = RFC_768.Port(8080)
        #expect(port.rawValue == 8080)
        #expect(port.description == "8080")
    }

    @Test
    func `a port literal reads as its number`() {
        let port: RFC_768.Port = 8080
        #expect(port == RFC_768.Port(8080))
    }

    @Test(arguments: [
        (RFC_768.Port.dns, UInt16(53)),
        (RFC_768.Port.dhcp, 67),
        (RFC_768.Port.tftp, 69),
        (RFC_768.Port.ntp, 123),
        (RFC_768.Port.snmp, 161),
        (RFC_768.Port.syslog, 514),
    ])
    func `the well-known service ports carry their assigned numbers`(port: RFC_768.Port, number: UInt16) {
        #expect(port.rawValue == number)
        #expect(port.isWellKnown)
    }

    @Test
    func `ports classify as well-known, registered or dynamic`() {
        let wellKnown = RFC_768.Port(80)
        let registered = RFC_768.Port(8080)
        let dynamic = RFC_768.Port(50000)

        #expect(wellKnown.isWellKnown)
        #expect(!wellKnown.isRegistered)
        #expect(!wellKnown.isDynamic)

        #expect(!registered.isWellKnown)
        #expect(registered.isRegistered)
        #expect(!registered.isDynamic)

        #expect(!dynamic.isWellKnown)
        #expect(!dynamic.isRegistered)
        #expect(dynamic.isDynamic)
    }
}

extension `RFC 768 Tests`.`Length Tests` {

    @Test
    func `a length counts the header and the payload`() throws {
        let length = try RFC_768.Length(20)
        #expect(length.rawValue == 20)
        #expect(length.data == 12)
        #expect(length.description == "20")
    }

    @Test
    func `the minimum length carries no payload`() throws {
        let length = try RFC_768.Length(RFC_768.minimumLength)
        #expect(length.rawValue == 8)
        #expect(length.data == 0)
    }

    @Test
    func `a length below the eight-byte header is refused`() {
        #expect(throws: RFC_768.Length.Error.tooShort(7)) {
            try RFC_768.Length(7)
        }
        #expect(throws: RFC_768.Length.Error.tooShort(0)) {
            try RFC_768.Length(rawValue: 0)
        }
    }
}

extension `RFC 768 Tests`.`Checksum Tests` {

    @Test
    func `the zero checksum means absent`() {
        #expect(RFC_768.Checksum.zero.rawValue == 0)
        #expect(RFC_768.Checksum.zero.isAbsent)
    }

    @Test
    func `a non-zero checksum is present and reads as hexadecimal`() {
        let checksum = RFC_768.Checksum(rawValue: 0xABCD)
        #expect(!checksum.isAbsent)
        #expect(checksum.description == "0xABCD")
    }
}

extension `RFC 768 Tests`.`Header Tests` {

    @Test
    func `a header carries its four fields`() throws {
        let header = RFC_768.Header(
            source: .init(12345),
            destination: .dns,
            length: try .init(20),
            checksum: .zero
        )
        #expect(header.source.rawValue == 12345)
        #expect(header.destination == .dns)
        #expect(header.length.rawValue == 20)
        #expect(header.checksum.isAbsent)
    }
}

extension `RFC 768 Tests`.`Pseudo Header Tests` {

    @Test
    func `a pseudo header carries the addresses and length the checksum covers`() throws {
        let pseudoHeader = RFC_768.PseudoHeader(
            source: try .init("192.168.1.1"),
            destination: try .init("192.168.1.2"),
            length: 12
        )
        #expect(pseudoHeader.source == RFC_791.IPv4.Address(rawValue: 0xC0A8_0101))
        #expect(pseudoHeader.destination == RFC_791.IPv4.Address(rawValue: 0xC0A8_0102))
        #expect(pseudoHeader.length == 12)
    }
}

extension `RFC 768 Tests`.`Datagram Tests` {

    @Test
    func `a datagram measures its own length`() throws {
        let data = bytes(0x01, 0x01, 0x01, 0x01)
        let datagram = try RFC_768.Datagram(
            source: .init(12345),
            destination: .dns,
            data: data
        )
        #expect(datagram.header.source.rawValue == 12345)
        #expect(datagram.header.destination == .dns)
        #expect(datagram.header.length.rawValue == UInt16(RFC_768.headerSize) + 4)
        #expect(datagram.header.length.data == 4)
        #expect(datagram.header.checksum.isAbsent)
        #expect(datagram.data == data)
    }

    @Test
    func `a datagram without a payload is the minimum length`() throws {
        let datagram = try RFC_768.Datagram(source: .dns, destination: .init(12345), data: [])
        #expect(datagram.header.length.rawValue == RFC_768.minimumLength)
        #expect(datagram.data.isEmpty)
    }

    @Test
    func `a datagram keeps the checksum it is given`() throws {
        let datagram = try RFC_768.Datagram(
            source: .init(8080),
            destination: .syslog,
            data: bytes(0xDE, 0xAD),
            checksum: RFC_768.Checksum(rawValue: 0xABCD)
        )
        #expect(datagram.header.checksum.rawValue == 0xABCD)
    }

    @Test
    func `a datagram built from a header keeps that header`() throws {
        let header = RFC_768.Header(
            source: .ntp,
            destination: .init(50000),
            length: try .init(12),
            checksum: .zero
        )
        let datagram = RFC_768.Datagram(header: header, data: bytes(1, 2, 3, 4))
        #expect(datagram.header == header)
        #expect(datagram.data == bytes(1, 2, 3, 4))
    }

    @Test
    func `a payload the length field cannot describe is refused`() {
        let data = [Byte](repeating: Byte(bitPattern: 0), count: Int(UInt16.max))
        #expect(throws: RFC_768.Datagram.Error.dataTooLarge(Int(UInt16.max))) {
            try RFC_768.Datagram(source: .init(1), destination: .init(2), data: data)
        }
    }

    @Test
    func `the largest payload the length field describes is accepted`() throws {
        let data = [Byte](repeating: Byte(bitPattern: 0), count: Int(UInt16.max) - RFC_768.headerSize)
        let datagram = try RFC_768.Datagram(source: .init(1), destination: .init(2), data: data)
        #expect(datagram.header.length.rawValue == UInt16.max)
    }
}

extension `RFC 768 Tests`.`Specification Tests` {

    @Test
    func `the specification pins the protocol number and the header size`() {
        #expect(RFC_768.protocolNumber == .udp)
        #expect(RFC_768.protocolNumber.rawValue == 17)
        #expect(RFC_768.minimumLength == 8)
        #expect(RFC_768.headerSize == 8)
    }
}
