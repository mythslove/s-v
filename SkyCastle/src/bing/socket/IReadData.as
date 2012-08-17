package bing.socket
{
	public interface IReadData
	{
		function readInt( name:String ):int ;
		function readUInt( name:String ):uint ;
		
		function readShort( name:String ):Number ;
		function readUShort( name:String ):Number ;
		
		function readDouble( name:String ):Number ;
		
		function readNull( name:String  ):Object ;
		
		function readBoolean( name:String   ):Boolean ;
		
		function readByte( name:String ):int ;
		function readUByte( name:String ):int ;
		
		function readUTF( name:String  ):String ;
		
		
		
		
		
		
		function readIntArray( name:String  ):Array ;
		function readUIntArray( name:String  ):Array ;
		
		function readShortArray( name:String ):Array ;
		function readUShortArray( name:String ):Array ;
		
		function readByteArray( name:String ):Array ;
		function readUByteArray( name:String ):Array ;
		
		function readBoolArray( name:String ):Array ;
		
		function readDoubleArray( name:String ):Array ;
		
		function readUTFArray( name:String ):Array ;
		
		
		
		
		function read( name:String ):* ;
	}
}