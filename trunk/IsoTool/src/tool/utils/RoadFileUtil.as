package tool.utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
	import tool.views.components.RoadComponent;

	public class RoadFileUtil
	{
		private static var file:File ;
		private static var container:DisplayObjectContainer ;
		
		
		public static function saveAsBuilding( $container:DisplayObjectContainer):void
		{
			container = $container ;
			file = new File();
			file.addEventListener(Event.SELECT , onSelectedSaveFile , false , 0 , true );
			file.browseForSave( "保存" );
		}
		
		public static function saveBuilding($file:File ,  $container:DisplayObjectContainer):void
		{
			container = $container ;
			if($file){
				file = $file ;
				onSelectedSaveFile(null);
			}else{
				saveAsBuilding($container);
			}
		}
		
		private static function onSelectedSaveFile(e:Event):void
		{
			file.removeEventListener(Event.SELECT , onSelectedSaveFile);
			if( file.nativePath.indexOf(".rd")==-1 ){
				file = new File( file.nativePath+".rd");
			}
			var stream:FileStream = new FileStream();
			stream.open( file , FileMode.WRITE );
			var bytes:ByteArray = new ByteArray();
			
			var count:int ;
			for( var i:int = 0 ; i<container.numChildren ; ++i)
			{
				road = container.getChildAt(i) as RoadComponent;
				if(road && road.bmd) ++count ;	
			}
			bytes.writeByte( count );
			var road:RoadComponent ;
			for( i = 0 ; i<count ; ++i)
			{
				road = container.getChildAt(i) as RoadComponent;
				if(road && road.bmd ){
					bytes.writeShort( road.x-road.rightX ); //偏移值
					bytes.writeShort( road.y-road.rightY );
					
					var pngBytes:ByteArray = road.bmd.getPixels( road.bmd.rect) ;
					bytes.writeShort( road.bmd.rect.width);
					bytes.writeShort( road.bmd.rect.height);
					bytes.writeDouble( pngBytes.length );
					bytes.writeBytes( pngBytes);
				}
			}
			bytes.compress();
			stream.writeBytes(bytes);
			stream.close();
			Alert.show( "保存成功" );
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		public static function readRoad(  file:File ,  $container:DisplayObjectContainer ):void
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
				var num:int = bytes.readUnsignedByte() ; //路块的数量
				var road:RoadComponent ;
				for( var i:int = 0 ; i<num ; ++i)
				{
					road = $container.getChildAt(i) as RoadComponent ;
					if(road)
					{
						var offsetX:int = bytes.readShort();
						var offsetY:int = bytes.readShort();
						var rect:Rectangle = new Rectangle(0,0 , bytes.readUnsignedShort() , bytes.readUnsignedShort());
						var pngBytes:ByteArray =new ByteArray();
						bytes.readBytes( pngBytes, 0 , bytes.readDouble() );
						var bmd:BitmapData = new BitmapData( rect.width , rect.height );
						bmd.setPixels( rect , pngBytes );
						road.showRoad( offsetX, offsetY , bmd );
					}
					stream.close();
				}
			}
		}
	}
}