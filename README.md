# swift-rfc-768

Use this package when you build, read or checksum UDP datagrams as defined by RFC 768. Start from `RFC_768.Datagram`, and use `RFC_768.PseudoHeader` with `RFC_768.Datagram.withChecksum(pseudo:)` when the datagram needs a checksum. IPv4 addresses come from swift-rfc-791.

## Laws

- The length field counts the whole datagram, the eight header bytes included. A length below 8 is refused, and `RFC_768.Length.data` is the payload size.
- Building a datagram from ports and a payload sets the length for you and refuses a payload longer than 65527 bytes. The checksum defaults to zero.
- A zero checksum means the sender sent none. A checksum that computes to zero is sent as `0xFFFF` instead, so a computed checksum is never absent.
- The checksum covers the pseudo header (source address, destination address, a zero octet, protocol 17 and the UDP length), then the header with its checksum field zeroed, then the payload. An odd-length payload is padded with one zero octet for the sum and not on the wire.
- `RFC_768.Checksum.verify(pseudo:header:data:)` is true when the ones' complement sum over all three parts is all ones. A datagram sent without a checksum will usually not verify, so check `RFC_768.Checksum.isAbsent` first.
- Ports are well-known below 1024, registered from 1024 to 49151 and dynamic from 49152.
- On the wire every field is two bytes in network order. Parsing a datagram reads exactly the payload length the header declares and leaves any bytes after it in the input. A failed parse puts the input back where it started and names the field that failed.
- With `RFC 768 Foundation Integration`, a port, length or checksum encodes as its number. A length below 8 fails to decode with a data-corrupted `DecodingError`.
