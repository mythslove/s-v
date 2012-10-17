package tool.utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
	import tool.local.vos.BitmapAnimResVO;
	import tool.views.components.AnimObject;
	import tool.views.components.RoadsLayerObject;

	/**
	 * 保存和读取建筑资源的工具类 
	 * @author zhouzhanglin
	 * 
	 */	
	public class BuildingFileUtil
	{
		private static var file:File ;
		private static var container:DisplayObjectContainer ;
		public static var gridX:int ;
		public static var gridZ:int ;
		
		public static function saveBuilding( $container:DisplayObjectContainer , $gridX:int , $gridZ:int  ):void
		{
			container = $container ;
			gridX = $gridX ;
			gridZ = $gridZ ;
			if(container.numChildren==0 || gridX<1 || gridZ<1 ) return ;
			
			file = new File();
			file.addEventListener(Event.SELECT , onSelectedSaveFile , false , 0 , true );
			file.browseForSave( "保存" );
		}
		
		private static function onSelectedSaveFile(e:Event):void
		{
			file.removeEventListener(Event.SELECT , onSelectedSaveFile);
			if( file.nativePath.indexOf(".bd")==-1 ){
				file = new File( file.nativePath+".bd");
			}
			var stream:FileStream = new FileStream();
			stream.open( file , FileMode.WRITE );
			var bytes:ByteArray = new ByteArray();
			bytes.writeByte( gridX );
			bytes.writeByte( gridZ );
			bytes.writeByte( container.numChildren );
			
			var obj:AnimObject ;
			var vo:BitmapAnimResVO ;
			for( var i:int = 0 ; i<container.numChildren ; ++i)
			{
				obj = container.getChildAt(i) as RoadsLayerObject;
				if(obj){
					vo = obj.vo ;
					writeRoadsLayerObject( vo , bytes );
					continue ;
				}
				obj = container.getChildAt(i) as AnimObject;
				if(obj){
					vo = obj.vo ;
					writeAnimObject( vo , bytes );
				}
			}
			bytes.compress();
			stream.writeBytes(bytes);
			stream.close();
			Alert.show( "保存成功" );
		}
		
		
		private static function writeAnimObject( vo:BitmapAnimResVO ,  bytes:ByteArray ):void
		{
			bytes.writeBoolean( true ); //普通图片
			bytes.writeShort( vo.offsetX );
			bytes.writeShort( vo.offsetY );
			var len:int = vo.bmds.length ;
			bytes.writeByte( len );
			var pngBytes:ByteArray ;
			for( var j:int = 0 ; j<len ; ++j )
			{
				pngBytes = vo.bmds[j].getPixels( vo.bmds[j].rect) ;
				bytes.writeShort( vo.bmds[j].rect.width);
				bytes.writeShort( vo.bmds[j].rect.height);
				bytes.writeDouble( pngBytes.length );
				bytes.writeBytes( pngBytes);
			}
			
			bytes.writeBoolean( vo.isAnim );
			if(vo.isAnim)
			{
				bytes.writeByte( vo.row );
				bytes.writeByte( vo.col );
				bytes.writeByte( vo.frame );
				bytes.writeByte( vo.rate );
			}
		}
		
		private static function writeRoadsLayerObject(vo:BitmapAnimResVO ,  bytes:ByteArray ):void
		{
			bytes.writeBoolean(false);//路点
			var len:int = vo.roads.length ;
			bytes.writeByte( len );
			for( var i:int = 0 ; i<len ; ++i )
			{
				bytes.writeShort( vo.roads[i].x );
				bytes.writeShort( vo.roads[i].y );
			}
		}
		
		
		
		
		
		
		
		
		

		public static function readBuilding( file:File ,  $container:DisplayObjectContainer ):void
		{
			var stream:FileStream = new FileStream();
			try{
				stream.open( file , FileMode.READ );
				var bytes:ByteArray = new ByteArray();
				stream.readBytes( bytes );
				bytes.position = 0 ;
				bytes.uncompress();
			}
			catch(e:Error){}
			finally
			{
				gridX =  bytes.readUnsignedByte() ;
				gridZ =  bytes.readUnsignedByte() ;
				var num:int = bytes.readUnsignedByte() ;
				var vo:BitmapAnimResVO; 
				var obj:AnimObject ;
				for( var i:int = 0 ; i<num ; ++i)
				{
					vo = new BitmapAnimResVO();
					if( bytes.readBoolean()){
						readAnimObject(vo ,bytes );
						obj = new AnimObject();
					}else{
						readRoadsLayerObject(vo ,bytes );
						obj = new RoadsLayerObject();
					}
					$container.addChild( obj );
					obj.setAnimResVO( vo );
					stream.close();
				}
			}
			
		}
		
		
		private static function readAnimObject( vo:BitmapAnimResVO , bytes:ByteArray ):void
		{
			vo.offsetX = bytes.readShort() ;
			vo.offsetY = bytes.readShort() ;
			
			var len:int = bytes.readUnsignedByte() ;
			vo.bmds = new Vector.<BitmapData>(len,true);
			var bmd:BitmapData ;
			var rect:Rectangle ;
			var pngBytes:ByteArray ;
			for( var j:int = 0 ; j<len ; ++j )
			{
				rect = new Rectangle(0,0 , bytes.readUnsignedShort() , bytes.readUnsignedShort());
				pngBytes = new ByteArray();
				bytes.readBytes( pngBytes, 0 , bytes.readDouble() );
				bmd = new BitmapData( rect.width , rect.height );
				bmd.setPixels( rect , pngBytes );
				vo.bmds[j] = bmd ;
			}
			
			vo.isAnim = bytes.readBoolean() ;
			if(vo.isAnim)
			{
				vo.row = bytes.readUnsignedByte() ;
				vo.col =bytes.readUnsignedByte() ; 
				vo.frame = bytes.readUnsignedByte() ;
				vo.rate = bytes.readUnsignedByte() ;
			}
			vo.mergeBmds();
		}
		
		private static function readRoadsLayerObject( vo:BitmapAnimResVO , bytes:ByteArray ):void
		{
			var len:int = bytes.readUnsignedByte() ;
			var p:Point ;
			vo.roads = new Vector.<Point>( len , true );
			for( var i:int = 0 ; i<len ; ++i )
			{
				p = new Point(bytes.readShort(),bytes.readShort());
				vo.roads[i] = p ;
			}
		}
		
		
	}
}