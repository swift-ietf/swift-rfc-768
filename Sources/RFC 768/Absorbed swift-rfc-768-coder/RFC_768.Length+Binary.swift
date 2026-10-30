#if Coder
    public import Binary
    public import Byte

    extension RFC_768.Length: Binary.Serializable {

        public static func serialize<Buffer: RangeReplaceableCollection>(
            _ length: Self,
            into buffer: inout Buffer
        ) where Buffer.Element == Byte {
            buffer.append(Byte(bitPattern: UInt8(length.rawValue >> 8)))
            buffer.append(Byte(bitPattern: UInt8(length.rawValue & 0xFF)))
        }
    }
#endif
