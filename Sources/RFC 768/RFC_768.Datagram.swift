public import Byte

extension RFC_768 {

    public struct Datagram: Hashable, Sendable {
        public let header: Header
        public let data: [Byte]

        public init(header: Header, data: [Byte]) {
            self.header = header
            self.data = data
        }
    }
}

extension RFC_768.Datagram {

    public init(
        source: RFC_768.Port,
        destination: RFC_768.Port,
        data: [Byte],
        checksum: RFC_768.Checksum = .zero
    ) throws(Error) {
        let totalLength = RFC_768.headerSize + data.count

        guard totalLength <= Int(UInt16.max) else {
            throw .dataTooLarge(data.count)
        }

        let length: RFC_768.Length
        do throws(RFC_768.Length.Error) {
            length = try RFC_768.Length(UInt16(totalLength))
        } catch {
            throw .length(error)
        }

        self.header = RFC_768.Header(
            source: source,
            destination: destination,
            length: length,
            checksum: checksum
        )
        self.data = data
    }
}
