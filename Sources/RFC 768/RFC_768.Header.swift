extension RFC_768 {

    public struct Header: Hashable, Sendable {
        public let source: Port
        public let destination: Port
        public let length: Length
        public let checksum: Checksum

        public init(
            source: Port,
            destination: Port,
            length: Length,
            checksum: Checksum
        ) {
            self.source = source
            self.destination = destination
            self.length = length
            self.checksum = checksum
        }
    }
}
