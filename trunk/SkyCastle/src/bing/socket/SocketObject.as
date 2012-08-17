package bing.socket
{
	import flash.utils.ByteArray;
	
	/**
	 * e,g
	 * <p>
	 * //写
	 * var so:SocketObject = new SocketObject( );
		so.writeByte("abc",34);
		so.writeIntArray( "ok",[3,56,7,8]);
		so.writeBoolean( "bool",true );
		so.writeUTF( "myname","bingheliefeng" );
		var bytes:ByteArray = so.build() ;
		
		//读取
		so = new SocketObject( bytes,false);
		trace( so.read("bool") );
		trace( so.read("myname") );
		trace( so.read("abc") );
		trace( so.read("ok") );
	 * 
	 * </p> 
	 * @author zhouzhanglin
	 */	
	public class SocketObject implements IWriteData
	{
		private var _reader:IReadData ;
		private var _writer:IWriteData;
		
		/**
		 * @param bytes
		 * @param isWrite 是否为写数据 , 默认为写数据
		 */		
		public function SocketObject( bytes:ByteArray = null , isWrite:Boolean=true )
		{
			if(isWrite) _writer = new WriteData( bytes );
			else _reader = new ReadData( bytes );
		}
		
		public function read( name:String ):*
		{
			return _reader.read( name ); 
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		public function writeInt(name:String, value:int):void
		{
			_writer.writeInt( name , value );
		}
		
		public function writeShort(name:String, value:int):void
		{
			_writer.writeShort( name , value );
		}
		
		public function writeDouble(name:String, value:Number):void
		{
			_writer.writeDouble( name , value );
		}
		
		public function writeNull(name:String):void
		{
			_writer.writeNull( name );
		}
		
		public function writeBoolean(name:String, value:Boolean):void
		{
			_writer.writeBoolean( name , value );
		}
		
		public function writeByte(name:String, value:int):void
		{
			_writer.writeByte( name , value );
		}
		
		public function writeUTF(name:String, value:String):void
		{
			_writer.writeUTF( name , value );
		}
		
		public function writeIntArray(name:String, value:Array):void
		{
			_writer.writeIntArray( name , value );
		}
		
		public function writeShortArray(name:String, value:Array):void
		{
			_writer.writeShortArray( name , value );
		}
		
		public function writeBoolArray(name:String, value:Array):void
		{
			_writer.writeBoolArray( name , value );
		}
		
		public function writeByteArray(name:String, value:Array):void
		{
			_writer.writeByteArray( name , value );
		}
		
		public function writeDoubleArray(name:String, value:Array):void
		{
			_writer.writeDoubleArray( name , value );
		}
		
		public function writeUTFArray(name:String, value:Array):void
		{
			_writer.writeUTFArray( name , value );
		}
		
		public function build():ByteArray
		{
			return _writer.build() ;
		}
	}
}