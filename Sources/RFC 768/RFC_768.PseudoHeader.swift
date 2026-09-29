public import RFC_791

extension RFC_768 {

    public struct PseudoHeader: Hashable, Sendable {

        public let source: RFC_791.IPv4.Address

        public let destination: RFC_791.IPv4.Address

        public let length: UInt16

        public init(
            source: RFC_791.IPv4.Address,
            destination: RFC_791.IPv4.Address,
            length: UInt16
        ) {
            self.source = source
            self.destination = destination
            self.length = length
        }
    }
}
