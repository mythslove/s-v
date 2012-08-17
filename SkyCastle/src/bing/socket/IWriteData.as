package bing.socket
{
	import flash.utils.ByteArray;

	public interface IWriteData
	{
		function writeInt( name:String , value:int ):void ;
		
		function writeShort( name:String , value:int ):void ;
		
		function writeDouble( name:String , value:Number ):void ;
		
		function writeNull( name:String  ):void ;
		
		function writeBoolean( name:String , value:Boolean  ):void ;
		
		function writeByte( name:String , value:int  ):void ;
		
		function writeUTF( name:String , value:String  ):void ;
		
		
		
		
		
		
		function writeIntArray( name:String , value:Array ):void ;

		function writeShortArray( name:String , value:Array ):void ;
		
		function writeBoolArray( name:String , value:Array ):void ;
		
		function writeByteArray( name:String , value:Array ):void ;
		
		function writeDoubleArray( name:String , value:Array ):void ;
		
		function writeUTFArray( name:String , value:Array ):void ;
		
		
		
		
		
		
		function build():ByteArray ;
	}
}