#if Coder
    public import Binary
    public import Byte

    extension RFC_768.Datagram: Binary.Serializable {

        public static func serialize<Buffer: RangeReplaceableCollection>(
            _ datagram: Self,
            into buffer: inout Buffer
        ) where Buffer.Element == Byte {
            RFC_768.Header.serialize(datagram.header, into: &buffer)
            buffer.append(contentsOf: datagram.data)
        }
    }
#endif
