# RFC 768

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)
[![CI](https://github.com/swift-ietf/swift-rfc-768/workflows/CI/badge.svg)](https://github.com/swift-ietf/swift-rfc-768/actions/workflows/ci.yml)

Swift implementation of RFC 768: User Datagram Protocol.

## Overview

This package is the pure domain model of the UDP datagram defined in RFC 768 (August 1980): the port, length and checksum fields are distinct types carrying their invariants and well-known values, the header and datagram compose them, and the pseudo-header names the IPv4 addresses the checksum covers. It has no parser, serializer or formatter dependencies.

The wire forms live in the sibling package [swift-rfc-768-coder](https://github.com/swift-ietf/swift-rfc-768-coder): `<Type>.Coder` over a byte cursor for every field, the header and the datagram, `Binary.Serializable` conformances, the pseudo-header serialization and the one's-complement checksum computation.

## Products

- `RFC 768` — the domain model.
- `RFC 768 Standard Library Integration` — `RFC_768.Datagram` initializers taking a `[UInt8]` payload.
- `RFC 768 Foundation Integration` — `Codable` for `Port`, `Length` and `Checksum` (each codes as its raw number).

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-ietf/swift-rfc-768.git", branch: "main")
]
```

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "RFC 768", package: "swift-rfc-768")
    ]
)
```

## Quick Start

```swift
import Byte
import RFC_768
import RFC_791

let datagram = try RFC_768.Datagram(
    source: .init(12345),
    destination: .dns,
    data: [Byte](repeating: Byte(bitPattern: 0), count: 4)
)

datagram.header.length.rawValue   // 12
datagram.header.length.data       // 4
datagram.header.checksum.isAbsent // true

let pseudoHeader = RFC_768.PseudoHeader(
    source: try .init("192.168.1.1"),
    destination: try .init("192.168.1.2"),
    length: datagram.header.length.rawValue
)

RFC_768.protocolNumber            // RFC_791.`Protocol`.udp
```

## Usage

### Ports

```swift
RFC_768.Port.dns.rawValue         // 53
RFC_768.Port(8080).isRegistered   // true
RFC_768.Port(50000).isDynamic     // true
```

### Length

```swift
try RFC_768.Length(20).data       // 12
try RFC_768.Length(7)             // throws RFC_768.Length.Error.tooShort(7)
```

## Header format

```
 0      7 8     15 16    23 24    31
+--------+--------+--------+--------+
|     Source      |   Destination   |
|      Port       |      Port       |
+--------+--------+--------+--------+
|                 |                 |
|     Length      |    Checksum     |
+--------+--------+--------+--------+
|          data octets ...
+---------------- ...
```

| Field | Bits | Type |
|-------|------|------|
| Source Port | 16 | `RFC_768.Port` |
| Destination Port | 16 | `RFC_768.Port` |
| Length | 16 | `RFC_768.Length` |
| Checksum | 16 | `RFC_768.Checksum` |

## License

This package is licensed under the Apache License 2.0. See [LICENSE.md](LICENSE.md) for details.
