/**
 * Autogenerated by Thrift
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 *  @generated
 */

package test.fixtures.complex_struct;

import com.facebook.swift.codec.*;
import com.facebook.swift.codec.ThriftField.Requiredness;
import com.facebook.swift.codec.ThriftField.Recursiveness;
import com.google.common.collect.*;
import java.util.*;
import javax.annotation.Nullable;
import org.apache.thrift.*;
import org.apache.thrift.transport.*;
import org.apache.thrift.protocol.*;
import static com.google.common.base.MoreObjects.toStringHelper;
import static com.google.common.base.MoreObjects.ToStringHelper;

@SwiftGenerated
@com.facebook.swift.codec.ThriftStruct(value="TypeRemapped", builder=TypeRemapped.Builder.class)
public final class TypeRemapped implements com.facebook.thrift.payload.ThriftSerializable {

    @ThriftConstructor
    public TypeRemapped(
        @com.facebook.swift.codec.ThriftField(value=1, name="lsMap", requiredness=Requiredness.NONE) final it.unimi.dsi.fastutil.longs.Long2ObjectArrayMap<String> lsMap,
        @com.facebook.swift.codec.ThriftField(value=2, name="ioMap", requiredness=Requiredness.NONE) final it.unimi.dsi.fastutil.ints.Int2ObjectArrayMap<it.unimi.dsi.fastutil.ints.Int2LongArrayMap> ioMap,
        @com.facebook.swift.codec.ThriftField(value=3, name="BigInteger", requiredness=Requiredness.NONE) final java.math.BigInteger bigInteger,
        @com.facebook.swift.codec.ThriftField(value=4, name="binaryTestBuffer", requiredness=Requiredness.NONE) final java.nio.ByteBuffer binaryTestBuffer
    ) {
        this.lsMap = lsMap;
        this.ioMap = ioMap;
        this.bigInteger = bigInteger;
        this.binaryTestBuffer = binaryTestBuffer;
    }
    
    @ThriftConstructor
    protected TypeRemapped() {
      this.lsMap = null;
      this.ioMap = null;
      this.bigInteger = 0;
      this.binaryTestBuffer = null;
    }
    
    public static class Builder {
    
        private it.unimi.dsi.fastutil.longs.Long2ObjectArrayMap<String> lsMap = null;
        private it.unimi.dsi.fastutil.ints.Int2ObjectArrayMap<it.unimi.dsi.fastutil.ints.Int2LongArrayMap> ioMap = null;
        private java.math.BigInteger bigInteger = 0;
        private java.nio.ByteBuffer binaryTestBuffer = null;
    
        @com.facebook.swift.codec.ThriftField(value=1, name="lsMap", requiredness=Requiredness.NONE)
        public Builder setLsMap(it.unimi.dsi.fastutil.longs.Long2ObjectArrayMap<String> lsMap) {
            this.lsMap = lsMap;
            return this;
        }
    
        public it.unimi.dsi.fastutil.longs.Long2ObjectArrayMap<String> getLsMap() { return lsMap; }
    
            @com.facebook.swift.codec.ThriftField(value=2, name="ioMap", requiredness=Requiredness.NONE)
        public Builder setIoMap(it.unimi.dsi.fastutil.ints.Int2ObjectArrayMap<it.unimi.dsi.fastutil.ints.Int2LongArrayMap> ioMap) {
            this.ioMap = ioMap;
            return this;
        }
    
        public it.unimi.dsi.fastutil.ints.Int2ObjectArrayMap<it.unimi.dsi.fastutil.ints.Int2LongArrayMap> getIoMap() { return ioMap; }
    
            @com.facebook.swift.codec.ThriftField(value=3, name="BigInteger", requiredness=Requiredness.NONE)
        public Builder setBigInteger(java.math.BigInteger bigInteger) {
            this.bigInteger = bigInteger;
            return this;
        }
    
        public java.math.BigInteger getBigInteger() { return bigInteger; }
    
            @com.facebook.swift.codec.ThriftField(value=4, name="binaryTestBuffer", requiredness=Requiredness.NONE)
        public Builder setBinaryTestBuffer(java.nio.ByteBuffer binaryTestBuffer) {
            this.binaryTestBuffer = binaryTestBuffer;
            return this;
        }
    
        public java.nio.ByteBuffer getBinaryTestBuffer() { return binaryTestBuffer; }
    
        public Builder() { }
        public Builder(TypeRemapped other) {
            this.lsMap = other.lsMap;
            this.ioMap = other.ioMap;
            this.bigInteger = other.bigInteger;
            this.binaryTestBuffer = other.binaryTestBuffer;
        }
    
        @ThriftConstructor
        public TypeRemapped build() {
            TypeRemapped result = new TypeRemapped (
                this.lsMap,
                this.ioMap,
                this.bigInteger,
                this.binaryTestBuffer
            );
            return result;
        }
    }
                    public static final Map<String, Integer> NAMES_TO_IDS = new HashMap();
    public static final Map<String, Integer> THRIFT_NAMES_TO_IDS = new HashMap();
    public static final Map<Integer, TField> FIELD_METADATA = new HashMap<>();
    private static final TStruct STRUCT_DESC = new TStruct("TypeRemapped");
    private final it.unimi.dsi.fastutil.longs.Long2ObjectArrayMap<String> lsMap;
    public static final int _LSMAP = 1;
    private static final TField LS_MAP_FIELD_DESC = new TField("lsMap", TType.MAP, (short)1);
        private final it.unimi.dsi.fastutil.ints.Int2ObjectArrayMap<it.unimi.dsi.fastutil.ints.Int2LongArrayMap> ioMap;
    public static final int _IOMAP = 2;
    private static final TField IO_MAP_FIELD_DESC = new TField("ioMap", TType.MAP, (short)2);
        private final java.math.BigInteger bigInteger;
    public static final int _BIGINTEGER = 3;
    private static final TField BIG_INTEGER_FIELD_DESC = new TField("BigInteger", TType.I32, (short)3);
        private final java.nio.ByteBuffer binaryTestBuffer;
    public static final int _BINARYTESTBUFFER = 4;
    private static final TField BINARY_TEST_BUFFER_FIELD_DESC = new TField("binaryTestBuffer", TType.STRING, (short)4);
    static {
      NAMES_TO_IDS.put("lsMap", 1);
      THRIFT_NAMES_TO_IDS.put("lsMap", 1);
      FIELD_METADATA.put(1, LS_MAP_FIELD_DESC);
      NAMES_TO_IDS.put("ioMap", 2);
      THRIFT_NAMES_TO_IDS.put("ioMap", 2);
      FIELD_METADATA.put(2, IO_MAP_FIELD_DESC);
      NAMES_TO_IDS.put("bigInteger", 3);
      THRIFT_NAMES_TO_IDS.put("BigInteger", 3);
      FIELD_METADATA.put(3, BIG_INTEGER_FIELD_DESC);
      NAMES_TO_IDS.put("binaryTestBuffer", 4);
      THRIFT_NAMES_TO_IDS.put("binaryTestBuffer", 4);
      FIELD_METADATA.put(4, BINARY_TEST_BUFFER_FIELD_DESC);
    }
    
    @Nullable
    @com.facebook.swift.codec.ThriftField(value=1, name="lsMap", requiredness=Requiredness.NONE)
    public it.unimi.dsi.fastutil.longs.Long2ObjectArrayMap<String> getLsMap() { return lsMap; }
    
    
    @Nullable
    @com.facebook.swift.codec.ThriftField(value=2, name="ioMap", requiredness=Requiredness.NONE)
    public it.unimi.dsi.fastutil.ints.Int2ObjectArrayMap<it.unimi.dsi.fastutil.ints.Int2LongArrayMap> getIoMap() { return ioMap; }
    
    
    
    @com.facebook.swift.codec.ThriftField(value=3, name="BigInteger", requiredness=Requiredness.NONE)
    public java.math.BigInteger getBigInteger() { return bigInteger; }
    
    
    @Nullable
    @com.facebook.swift.codec.ThriftField(value=4, name="binaryTestBuffer", requiredness=Requiredness.NONE)
    public java.nio.ByteBuffer getBinaryTestBuffer() { return binaryTestBuffer; }
    
    @java.lang.Override
    public String toString() {
        ToStringHelper helper = toStringHelper(this);
        helper.add("lsMap", lsMap);
        helper.add("ioMap", ioMap);
        helper.add("bigInteger", bigInteger);
        helper.add("binaryTestBuffer", binaryTestBuffer);
        return helper.toString();
    }
    
    @java.lang.Override
    public boolean equals(java.lang.Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
    
        TypeRemapped other = (TypeRemapped)o;
    
        return
            Objects.equals(lsMap, other.lsMap) &&
            Objects.equals(ioMap, other.ioMap) &&
            Objects.equals(bigInteger, other.bigInteger) &&
            Objects.equals(binaryTestBuffer, other.binaryTestBuffer) &&
            true;
    }
    
    @java.lang.Override
    public int hashCode() {
        return Arrays.deepHashCode(new java.lang.Object[] {
            lsMap,
            ioMap,
            bigInteger,
            binaryTestBuffer
        });
    }
    
    
    public static com.facebook.thrift.payload.Reader<TypeRemapped> asReader() {
      return TypeRemapped::read0;
    }
    
    public static TypeRemapped read0(TProtocol oprot) throws TException {
      TField __field;
      oprot.readStructBegin(TypeRemapped.NAMES_TO_IDS, TypeRemapped.THRIFT_NAMES_TO_IDS, TypeRemapped.FIELD_METADATA);
      TypeRemapped.Builder builder = new TypeRemapped.Builder();
      while (true) {
        __field = oprot.readFieldBegin();
        if (__field.type == TType.STOP) { break; }
        switch (__field.id) {
        case _LSMAP:
          if (__field.type == TType.MAP) {
            it.unimi.dsi.fastutil.longs.Long2ObjectArrayMap<String> lsMap;
            {
            TMap _map = oprot.readMapBegin();
            lsMap = new it.unimi.dsi.fastutil.longs.Long2ObjectArrayMap<String>();
            for (int _i = 0; (_map.size < 0) ? oprot.peekMap() : (_i < _map.size); _i++) {
                
                long _key1 = oprot.readI64();
                String _value1 = oprot.readString();
                lsMap.put(_key1, _value1);
            }
            }
            oprot.readMapEnd();
            builder.setLsMap(lsMap);
          } else {
            TProtocolUtil.skip(oprot, __field.type);
          }
          break;
        case _IOMAP:
          if (__field.type == TType.MAP) {
            it.unimi.dsi.fastutil.ints.Int2ObjectArrayMap<it.unimi.dsi.fastutil.ints.Int2LongArrayMap> ioMap;
            {
            TMap _map = oprot.readMapBegin();
            ioMap = new it.unimi.dsi.fastutil.ints.Int2ObjectArrayMap<it.unimi.dsi.fastutil.ints.Int2LongArrayMap>();
            for (int _i = 0; (_map.size < 0) ? oprot.peekMap() : (_i < _map.size); _i++) {
                
                int _key1 = oprot.readI32();
                it.unimi.dsi.fastutil.ints.Int2LongArrayMap _value1;
            {
            TMap _map1 = oprot.readMapBegin();
            _value1 = new it.unimi.dsi.fastutil.ints.Int2LongArrayMap();
            for (int _i1 = 0; (_map1.size < 0) ? oprot.peekMap() : (_i1 < _map1.size); _i1++) {
                
                
                int _key2 = oprot.readI32();
                

                
                long _value2 = oprot.readI64();
                
                
                _value1.put(_key2, _value2);
                
            }
            }
            oprot.readMapEnd();
                ioMap.put(_key1, _value1);
            }
            }
            oprot.readMapEnd();
            builder.setIoMap(ioMap);
          } else {
            TProtocolUtil.skip(oprot, __field.type);
          }
          break;
        case _BIGINTEGER:
          if (__field.type == TType.I32) {
            java.math.BigInteger bigInteger = oprot.readI32();
            builder.setBigInteger(bigInteger);
          } else {
            TProtocolUtil.skip(oprot, __field.type);
          }
          break;
        case _BINARYTESTBUFFER:
          if (__field.type == TType.STRING) {
            java.nio.ByteBuffer binaryTestBuffer = oprot.readBinary();
            builder.setBinaryTestBuffer(binaryTestBuffer);
          } else {
            TProtocolUtil.skip(oprot, __field.type);
          }
          break;
        default:
          TProtocolUtil.skip(oprot, __field.type);
          break;
        }
        oprot.readFieldEnd();
      }
      oprot.readStructEnd();
      return builder.build();
    }
    
    public void write0(TProtocol oprot) throws TException {
      oprot.writeStructBegin(STRUCT_DESC);
      if (lsMap != null) {
        oprot.writeFieldBegin(LS_MAP_FIELD_DESC);
        it.unimi.dsi.fastutil.longs.Long2ObjectArrayMap<String> _iter0 = lsMap;
        oprot.writeMapBegin(new TMap(TType.I64, TType.STRING, _iter0.size()));
        for (Map.Entry<Long, String> _iter1 : _iter0.entrySet()) {
          oprot.writeI64(_iter1.getKey());
          oprot.writeString(_iter1.getValue());
        }
        oprot.writeMapEnd();
        oprot.writeFieldEnd();
      }
      if (ioMap != null) {
        oprot.writeFieldBegin(IO_MAP_FIELD_DESC);
        it.unimi.dsi.fastutil.ints.Int2ObjectArrayMap<it.unimi.dsi.fastutil.ints.Int2LongArrayMap> _iter0 = ioMap;
        oprot.writeMapBegin(new TMap(TType.I32, TType.MAP, _iter0.size()));
        for (Map.Entry<Integer, it.unimi.dsi.fastutil.ints.Int2LongArrayMap> _iter1 : _iter0.entrySet()) {
          oprot.writeI32(_iter1.getKey());
          
          oprot.writeMapBegin(new TMap(TType.I32, TType.I64, _iter1.getValue().size()));
        for (Map.Entry<Integer, Long> _iter2 : _iter1.getValue().entrySet()) {
          oprot.writeI32(_iter2.getKey());
          oprot.writeI64(_iter2.getValue());
        }
        oprot.writeMapEnd();
        }
        oprot.writeMapEnd();
        oprot.writeFieldEnd();
      }
      oprot.writeFieldBegin(BIG_INTEGER_FIELD_DESC);
      oprot.writeI32(this.bigInteger);
      oprot.writeFieldEnd();
      if (binaryTestBuffer != null) {
        oprot.writeFieldBegin(BINARY_TEST_BUFFER_FIELD_DESC);
        oprot.writeBinary((this.binaryTestBuffer));
        oprot.writeFieldEnd();
      }
      oprot.writeFieldStop();
      oprot.writeStructEnd();
    }
    
    private static class _TypeRemappedLazy {
        private static final TypeRemapped _DEFAULT = new TypeRemapped.Builder().build();
    }
    
    public static TypeRemapped defaultInstance() {
        return  _TypeRemappedLazy._DEFAULT;
    }
}
