extension RFC_768 {

    public struct Checksum: RawRepresentable, Hashable, Sendable {
        public let rawValue: UInt16

        public init(rawValue: UInt16) {
            self.rawValue = rawValue
        }
    }
}

extension RFC_768.Checksum {

    public static let zero = RFC_768.Checksum(rawValue: 0)
}

extension RFC_768.Checksum {

    public var isAbsent: Bool { rawValue == 0 }
}

extension RFC_768.Checksum: CustomStringConvertible {
    public var description: String {
        "0x\(String(rawValue, radix: 16, uppercase: true))"
    }
}
