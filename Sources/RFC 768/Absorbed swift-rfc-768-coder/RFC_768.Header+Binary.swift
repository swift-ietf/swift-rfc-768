#if Coder
    public import Binary
    public import Byte

    extension RFC_768.Header: Binary.Serializable {

        public static func serialize<Buffer: RangeReplaceableCollection>(
            _ header: Self,
            into buffer: inout Buffer
        ) where Buffer.Element == Byte {
            RFC_768.Port.serialize(header.source, into: &buffer)
            RFC_768.Port.serialize(header.destination, into: &buffer)
            RFC_768.Length.serialize(header.length, into: &buffer)
            RFC_768.Checksum.serialize(header.checksum, into: &buffer)
        }
    }
#endif
