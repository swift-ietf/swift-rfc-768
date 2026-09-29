extension RFC_768 {

    public struct Length: Hashable, Sendable {
        public let rawValue: UInt16

        public init(rawValue: UInt16) throws(Error) {
            guard rawValue >= RFC_768.minimumLength else {
                throw .tooShort(rawValue)
            }
            self.rawValue = rawValue
        }

        public init(_ value: UInt16) throws(Error) {
            try self.init(rawValue: value)
        }
    }
}

extension RFC_768.Length {

    public var data: UInt16 {
        rawValue - RFC_768.minimumLength
    }
}

extension RFC_768.Length: CustomStringConvertible {
    public var description: String {
        String(rawValue)
    }
}
