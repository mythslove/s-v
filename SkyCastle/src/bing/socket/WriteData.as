package bing.socket
{
	import flash.utils.ByteArray;

	public class WriteData implements IWriteData
	{
		private var _bytes:ByteArray  ;
		private var _count:int ; //写了几组数据
		
		public function WriteData( bytes:ByteArray=null )
		{
				if(bytes) _bytes = bytes ;
				else _bytes = new ByteArray();
		}
		
		/**
		 * <p>写一个int类型的数据</p>
		 * <p>格式: name+type+value ( 名字+数据类型+数据)</p>
		 * @param name
		 * @param value
		 */		
		public function writeInt( name:String , value:int ):void
		{
			_bytes.writeUTF( name );
			_bytes.writeByte( DataType.DATA_TYPE_INT );
			_bytes.writeInt( value );
			++ _count ;
		}
		
		/**
		 * <p>写一个uint类型的数据</p>
		 * <p>格式: name+type+value ( 名字+数据类型+数据)</p>
		 * @param name
		 * @param value
		 */		
		public function writeUInt( name:String , value:uint ):void
		{
			_bytes.writeUTF( name );
			_bytes.writeByte( DataType.DATA_TYPE_UINT );
			_bytes.writeUnsignedInt( value );
			++ _count ;
		}
		
		/**
		 * <p>写一个short类型的数据</p>
		 * <p>格式: name+type+value ( 名字+数据类型+数据)</p>
		 * @param name
		 * @param value
		 */		
		public function writeShort( name:String , value:int ):void
		{
			_bytes.writeUTF( name );
			_bytes.writeByte( DataType.DATA_TYPE_SHORT );
			_bytes.writeShort ( value );
			++ _count ;
		}
		
		/**
		 * <p>写一个double类型的数据</p>
		 * <p>格式: name+type+value ( 名字+数据类型+数据)</p>
		 * @param name
		 * @param value
		 */		
		public function writeDouble( name:String , value:Number ):void
		{
			_bytes.writeUTF( name );
			_bytes.writeByte( DataType.DATA_TYPE_DOUBLE );
			_bytes.writeDouble ( value );
			++ _count ;
		}
		
		/**
		 * <p>表示null</p>
		 * <p>格式: name+type ( 名字+数据类型)</p>
		 * @param name
		 * @param value
		 */		
		public function writeNull( name:String  ):void
		{
			_bytes.writeUTF( name );
			_bytes.writeByte( DataType.DATA_TYPE_NULL );
			++ _count ;
		}
		
		/**
		 * <p>写一个bool类型值</p>
		 * <p>格式: name+type ( 名字+数据类型+数据)</p>
		 * @param name
		 * @param value
		 */		
		public function writeBoolean( name:String , value:Boolean  ):void
		{
			_bytes.writeUTF( name );
			_bytes.writeByte( DataType.DATA_TYPE_BOOL );
			if(value)	
				_bytes.writeByte( 1 );
			else 
				_bytes.writeByte( 0 );
			++ _count ;
		}
		
		/**
		 * <p>写一个Byte类型值</p>
		 * <p>格式: name+type ( 名字+数据类型+数据)</p>
		 * @param name
		 * @param value
		 */		
		public function writeByte( name:String , value:int  ):void
		{
			if( value>255) throw new Error("Byte值不能超过255");
			_bytes.writeUTF( name );
			_bytes.writeByte( DataType.DATA_TYPE_BYTE );
			_bytes.writeByte( value );
			++ _count ;
		}
		
		/**
		 * <p>写一个utf字符串类型值</p>
		 * <p>格式: name+type ( 名字+数据类型+数据)</p>
		 * @param name
		 * @param value
		 */		
		public function writeUTF(name:String, value:String):void
		{
			_bytes.writeUTF( name );
			_bytes.writeByte( DataType.DATA_TYPE_UTFSTRING );
			_bytes.writeUTF( value );
			++ _count ;
		}
		
		
		
		
		
		
		
		
		
		
		
		/**
		 * <p>写一个全是int类型的数组</p>
		 * <p>格式: name+type ( 名字+数据类型+数组长度(ushort类型)+数据)</p>
		 * @param name
		 * @param value 不能为null , 可以为[]空数组
		 */	
		public function writeIntArray( name:String , value:Array ):void
		{
			_bytes.writeUTF( name );
			_bytes.writeByte( DataType.DATA_TYPE_INT_ARRAY );
			var len:int = value.length ;
			_bytes.writeShort( len );
			for( var i:int = 0 ; i<len ; ++i )
			{
				_bytes.writeInt( value[i] );
			}
			++ _count ;
		}
		
		/**
		 * <p>写一个全是Uint类型的数组</p>
		 * <p>格式: name+type ( 名字+数据类型+数组长度(ushort类型)+数据)</p>
		 * @param name
		 * @param value 不能为null , 可以为[]空数组
		 */	
		public function writeUIntArray( name:String , value:Array ):void
		{
			_bytes.writeUTF( name );
			_bytes.writeByte( DataType.DATA_TYPE_UINT_ARRAY );
			var len:int = value.length ;
			_bytes.writeShort( len );
			for( var i:int = 0 ; i<len ; ++i )
			{
				_bytes.writeUnsignedInt( value[i] );
			}
			++ _count ;
		}
		
		/**
		 * <p>写一个全是short类型的数组</p>
		 * <p>格式: name+type ( 名字+数据类型+数组长度(ushort类型)+数据)</p>
		 * @param name
		 * @param value 不能为null , 可以为[]空数组
		 */	
		public function writeShortArray(name:String, value:Array):void
		{
			_bytes.writeUTF( name );
			_bytes.writeByte( DataType.DATA_TYPE_SHORT_ARRAY );
			var len:int = value.length ;
			_bytes.writeShort( len );
			for( var i:int = 0 ; i<len ; ++i )
			{
				_bytes.writeShort ( value[i] );
			}
			++ _count ;
		}
		
		/**
		 * <p>写一个全是Boolean类型的数组</p>
		 * <p>格式: name+type ( 名字+数据类型+数组长度(ushort类型)+数据)</p>
		 * @param name
		 * @param value 不能为null , 可以为[]空数组
		 */	
		public function writeBoolArray(name:String, value:Array):void
		{
			_bytes.writeUTF( name );
			_bytes.writeByte( DataType.DATA_TYPE_BOOL_ARRAY );
			var len:int = value.length ;
			_bytes.writeShort( len );
			for( var i:int = 0 ; i<len ; ++i )
			{
				if( value[i]) _bytes.writeByte(1);
				else _bytes.writeByte( -1 );
			}
			++ _count ;
		}
		
		/**
		 * <p>写一个全是Byte类型的数组</p>
		 * <p>格式: name+type ( 名字+数据类型+数组长度(ushort类型)+数据)</p>
		 * @param name
		 * @param value 不能为null , 可以为[]空数组
		 */	
		public function writeByteArray(name:String, value:Array):void
		{
			_bytes.writeUTF( name );
			_bytes.writeByte( DataType.DATA_TYPE_BYTE_ARRAY );
			var len:int = value.length ;
			_bytes.writeShort( len );
			for( var i:int = 0 ; i<len ; ++i )
			{
				_bytes.writeByte(value[i]);
			}
			++ _count ;
		}
		
		/**
		 * <p>写一个全是Double类型的数组</p>
		 * <p>格式: name+type ( 名字+数据类型+数组长度(ushort类型)+数据)</p>
		 * @param name
		 * @param value 不能为null , 可以为[]空数组
		 */	
		public function writeDoubleArray(name:String, value:Array):void
		{
			_bytes.writeUTF( name );
			_bytes.writeByte( DataType.DATA_TYPE_DOUBLE_ARRAY );
			var len:int = value.length ;
			_bytes.writeShort( len );
			for( var i:int = 0 ; i<len ; ++i )
			{
				_bytes.writeDouble(value[i]);
			}
			++ _count ;
		}
		
		/**
		 * <p>写一个全是UTF字符串类型的数组</p>
		 * <p>格式: name+type ( 名字+数据类型+数组长度(ushort类型)+数据)</p>
		 * @param name
		 * @param value 不能为null , 可以为[]空数组
		 */	
		public function writeUTFArray(name:String, value:Array):void
		{
			_bytes.writeUTF( name );
			_bytes.writeByte( DataType.DATA_TYPE_UTFSTRING_ARRAY );
			var len:int = value.length ;
			_bytes.writeShort( len );
			for( var i:int = 0 ; i<len ; ++i )
			{
				_bytes.writeUTF(value[i]);
			}
			++ _count ;
		}
		
		/**
		 * <p>写一个二进制数据</p>
		 * <p>格式: name+type ( 名字+数据类型+数组长度(ushort类型)+数据)</p>
		 * @param name
		 * @param value 不能为null 
		 */	
		public function writeUTFArray(name:String, value:ByteArray):void
		{
			_bytes.writeUTF( name );
			_bytes.writeByte( DataType.DATA_TYPE_BYTES );
			var len:int = value.length ;
			_bytes.writeBytes( value );
			++ _count ;
		}
		
		
		
		/**
		 * 最后创建完整的ByteArray 
		 * @return 
		 */		
		public function build():ByteArray 
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeByte( _count );
			_bytes.position = 0 ;
			bytes.writeBytes( _bytes );
			bytes.position = 0 ;
			return bytes ;
		}
	}
}