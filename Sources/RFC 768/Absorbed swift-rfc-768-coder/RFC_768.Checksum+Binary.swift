#if Coder
    public import Binary
    public import Byte

    extension RFC_768.Checksum: Binary.Serializable {

        public static func serialize<Buffer: RangeReplaceableCollection>(
            _ checksum: Self,
            into buffer: inout Buffer
        ) where Buffer.Element == Byte {
            buffer.append(Byte(bitPattern: UInt8(checksum.rawValue >> 8)))
            buffer.append(Byte(bitPattern: UInt8(checksum.rawValue & 0xFF)))
        }
    }
#endif
