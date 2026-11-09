extension RFC_768 {

    public struct Port: RawRepresentable, Hashable, Sendable {
        public let rawValue: UInt16

        public init(rawValue: UInt16) {
            self.rawValue = rawValue
        }

        public init(_ value: UInt16) {
            self.init(rawValue: value)
        }
    }
}

extension RFC_768.Port {

    public static let dns = Self(rawValue: 53)

    public static let dhcp = Self(rawValue: 67)

    public static let tftp = Self(rawValue: 69)

    public static let ntp = Self(rawValue: 123)

    public static let snmp = Self(rawValue: 161)

    public static let syslog = Self(rawValue: 514)
}

extension RFC_768.Port {

    public var isWellKnown: Bool { rawValue < 1024 }

    public var isRegistered: Bool { rawValue >= 1024 && rawValue < 49152 }

    public var isDynamic: Bool { rawValue >= 49152 }
}

extension RFC_768.Port: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: UInt16) {
        self.init(value)
    }
}

extension RFC_768.Port: CustomStringConvertible {
    public var description: String {
        String(rawValue)
    }
}
