public import RFC_791

extension RFC_768 {

    public static let protocolNumber: RFC_791.`Protocol` = .udp

    public static let minimumLength: UInt16 = 8

    public static let headerSize: Int = 8
}
