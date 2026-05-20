// RFC_768.Datagram+UInt8.swift
//
// Stdlib-interop UInt8 forwarders for `RFC_768.Datagram`. Primary byte-domain
// API lives in `RFC 768`; these forwarders bridge stdlib callers carrying
// `[UInt8]` (e.g. payloads from network buffers, file-read frames) by
// delegating to the byte-domain primary via `[Byte](data)`. Per
// [API-BYTE-007] (byte-discipline skill).

public import RFC_768
internal import Byte_Primitives

extension RFC_768.Datagram {
    /// Stdlib-interop forwarder: construction from `[UInt8]` payload.
    @_disfavoredOverload
    public init(header: Header, data: [UInt8]) {
        self.init(header: header, data: [Byte](data))
    }

    /// Stdlib-interop forwarder: construction from `[UInt8]` payload with auto length.
    @_disfavoredOverload
    public init(
        source: RFC_768.Port,
        destination: RFC_768.Port,
        data: [UInt8],
        checksum: RFC_768.Checksum = .zero
    ) throws(Error) {
        try self.init(source: source, destination: destination, data: [Byte](data), checksum: checksum)
    }
}
