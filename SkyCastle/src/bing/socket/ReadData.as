package bing.socket
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class ReadData implements IReadData
	{
		private var _data:Dictionary = new Dictionary() ;
		
		public function ReadData( bytes:ByteArray )
		{
			var count:int = bytes.readUnsignedByte() ; //组数量
			for( var i:int = 0 ; i<count ; ++i)
			{
				var name:String = bytes.readUTF() ;
				var type:int = bytes.readUnsignedByte() ;
				switch( type )
				{
					case DataType.DATA_TYPE_BOOL:
						_data[name] = ( bytes.readByte()==1 ) ;
						break ;
					case DataType.DATA_TYPE_NULL:
						_data[name] = null ;
						break ;
					case DataType.DATA_TYPE_BYTE:
						_data[name] = bytes.readByte()  ;
						break ;
					case DataType.DATA_TYPE_UBYTE:
						_data[name] = bytes.readUnsignedByte()  ;
						break ;
					case DataType.DATA_TYPE_DOUBLE:
						_data[name] = bytes.readDouble()  ;
						break ;
					case DataType.DATA_TYPE_INT:
						_data[name] = bytes.readInt() ;
						break ;
					case DataType.DATA_TYPE_UINT:
						_data[name] = bytes.readUnsignedInt()  ;
						break ;
					case DataType.DATA_TYPE_SHORT:
						_data[name] = bytes.readShort() ;
						break ;
					case DataType.DATA_TYPE_USHORT:
						_data[name] = bytes.readUnsignedShort() ;
						break ;
					case DataType.DATA_TYPE_UTFSTRING:
						_data[name] = bytes.readUTF() ;
						break ;
					
					
					case DataType.DATA_TYPE_BOOL_ARRAY:
						_data[name] = this.$readBoolArray( bytes ) ;
						break ;
					case DataType.DATA_TYPE_BYTE_ARRAY:
						_data[name] = this.$readByteArray( bytes ) ;
						break ;
					case DataType.DATA_TYPE_UBYTE_ARRAY:
						_data[name] = this.$readUByteArray( bytes ) ;
						break ;
					case DataType.DATA_TYPE_INT_ARRAY:
						_data[name] = this.$readIntArray( bytes ) ;
						break ;
					case DataType.DATA_TYPE_UINT_ARRAY :
						_data[name] = this.$readUIntArray( bytes ) ;
						break ;
					case DataType.DATA_TYPE_SHORT_ARRAY :
						_data[name] = this.$readShortArray( bytes ) ;
						break ;
					case DataType.DATA_TYPE_USHORT_ARRAY :
						_data[name] = this.$readUShortArray( bytes ) ;
						break ;
					case DataType.DATA_TYPE_DOUBLE_ARRAY :
						_data[name] = this.$readDoubleArray( bytes ) ;
						break ;
					case DataType.DATA_TYPE_UTFSTRING_ARRAY :
						_data[name] = this.$readUTFArray( bytes ) ;
						break ;
					case DataType.DATA_TYPE_BYTES :
						_data[name] = this.$readBytes( bytes ) ;
						break ;
				}
			}
			
		}
		
		/**
		 * 统一的接口，只是返回的类型不知道 
		 * @param name
		 * @return 
		 */		
		public function read( name:String ):*
		{
			return _data[name] ;
		}
		
		
		
		/**
		 * <p>写一个全是Double类型的数组</p>
		 * <p>格式: name+type ( 名字+数据类型+数组长度(ushort类型)+数据)</p>
		 * @param name
		 * @param value 不能为null , 可以为[]空数组
		 */	
		public function readInt(name:String):int
		{
			return _data[name];
		}
		
		public function readUInt(name:String):uint
		{
			return _data[name];
		}
		
		public function readShort(name:String):Number
		{
			return _data[name];
		}
		
		public function readUShort(name:String):Number
		{
			return _data[name];
		}
		
		public function readDouble(name:String):Number
		{
			return _data[name];
		}
		
		public function readNull(name:String):Object
		{
			return _data[name];
		}
		
		public function readBoolean(name:String):Boolean
		{
			return _data[name];
		}
		
		public function readByte(name:String):int
		{
			return _data[name];
		}
		
		public function readUByte(name:String):int
		{
			return _data[name];
		}
		
		public function readUTF(name:String):String
		{
			return _data[name];
		}
		
		
		
		
		
		
		
		
		
		
		public function readIntArray(name:String):Array
		{
			return _data[name];
		}
		private function $readIntArray( bytes:ByteArray ):Array
		{
			var arr:Array = [] ;
			var len:uint = bytes.readUnsignedShort() ;
			for( var i:int = 0 ; i<len ; ++i ){
				arr.push( bytes.readInt() );
			}
			return arr ;
		}
		
		public function readUIntArray(name:String):Array
		{
			return _data[name];
		}
		private function $readUIntArray( bytes:ByteArray ):Array
		{
			var arr:Array = [] ;
			var len:uint = bytes.readUnsignedShort() ;
			for( var i:int = 0 ; i<len ; ++i ){
				arr.push( bytes.readUnsignedInt() );
			}
			return arr ;
		}
		
		public function readShortArray(name:String):Array
		{
			return _data[name];
		}
		private function $readShortArray( bytes:ByteArray ):Array
		{
			var arr:Array = [] ;
			var len:uint = bytes.readUnsignedShort() ;
			for( var i:int = 0 ; i<len ; ++i ){
				arr.push( bytes.readShort() );
			}
			return arr ;
		}
		
		public function readUShortArray(name:String):Array
		{
			return _data[name];
		}
		private function $readUShortArray( bytes:ByteArray ):Array
		{
			var arr:Array = [] ;
			var len:uint = bytes.readUnsignedShort() ;
			for( var i:int = 0 ; i<len ; ++i ){
				arr.push( bytes.readUnsignedShort() );
			}
			return arr ;
		}
		
		public function readByteArray(name:String):Array
		{
			return _data[name];
		}
		private function $readByteArray( bytes:ByteArray ):Array
		{
			var arr:Array = [] ;
			var len:uint = bytes.readUnsignedShort() ;
			for( var i:int = 0 ; i<len ; ++i ){
				arr.push( bytes.readByte() );
			}
			return arr ;
		}
		
		public function readUByteArray(name:String):Array
		{
			return _data[name];
		}
		private function $readUByteArray( bytes:ByteArray ):Array
		{
			var arr:Array = [] ;
			var len:uint = bytes.readUnsignedShort() ;
			for( var i:int = 0 ; i<len ; ++i ){
				arr.push( bytes.readUnsignedByte() );
			}
			return arr ;
		}
		
		public function readBoolArray(name:String):Array
		{
			return _data[name];
		}
		private function $readBoolArray( bytes:ByteArray ):Array
		{
			var arr:Array = [] ;
			var len:uint = bytes.readUnsignedShort() ;
			for( var i:int = 0 ; i<len ; ++i ){
				if(bytes.readByte()==1) arr.push( true );
				else arr.push( false );
			}
			return arr ;
		}
		
		public function readDoubleArray(name:String):Array
		{
			return _data[name];
		}
		private function $readDoubleArray( bytes:ByteArray ):Array
		{
			var arr:Array = [] ;
			var len:uint = bytes.readUnsignedShort() ;
			for( var i:int = 0 ; i<len ; ++i ){
				arr.push( bytes.readDouble() );
			}
			return arr ;
		}
		
		public function readUTFArray(name:String):Array
		{
			return _data[name];
		}
		private function $readUTFArray( bytes:ByteArray ):Array
		{
			var arr:Array = [] ;
			var len:uint = bytes.readUnsignedShort() ;
			for( var i:int = 0 ; i<len ; ++i ){
				arr.push( bytes.readUTF() );
			}
			return arr ;
		}
		
		
		public function readBytes( name:String ):ByteArray 
		{
			return _data[name];
		}
		private function $readBytes( bytes:ByteArray ):ByteArray
		{
			var temp:ByteArray = new ByteArray();
			var len:uint = bytes.readUnsignedShort() ;
			bytes.readBytes( temp , bytes.position , len ) ;
			temp.position = 0 ;
			return  temp ;
		}
	}
}