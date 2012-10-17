package tool.utils
{
	import bing.iso.path.Grid;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.controls.Alert;
	
	import tool.local.vos.MapVO;

	public class MapFileUtil
	{
		private static var file:File ;
		private static var mapVO:MapVO ;
		
		public static function saveMap( $mapVO:MapVO ):void
		{
			mapVO = $mapVO ;
			file = new File();
			file.addEventListener(Event.SELECT , onSelectedSaveFile , false , 0  , true );
			file.browseForSave("保存地图");
		}
		
		
		private static function onSelectedSaveFile( e:Event ):void
		{
			file.removeEventListener(Event.SELECT , onSelectedSaveFile);
			if(file.nativePath.indexOf(".map")==-1){
				file = new File(file.nativePath+".map");
			}
			var stream:FileStream = new FileStream();
			stream.open( file , FileMode.WRITE );
			var grid:Grid = mapVO.gridData ;
			
			stream.writeShort( mapVO.offsetX );
			stream.writeShort( mapVO.offsetY );
			stream.writeByte( mapVO.xSpan );
			stream.writeByte( mapVO.zSpan );
			for( var i:int = 0 ; i<mapVO.xSpan ; ++i)
			{
				for( var j:int = 0 ; j<mapVO.zSpan ; ++j)
				{
					stream.writeBoolean( mapVO.gridData.getNode( i,j).walkable );
				}
			}
			stream.close() ;
			Alert.show( "保存成功" );
		}
		
		
		
		
		
		
		public static function readMapFile( mapFile:File ):MapVO
		{
			var stream:FileStream = new FileStream();
			stream.open( mapFile , FileMode.READ );
			var mapVO:MapVO = new MapVO();
			mapVO.offsetX = stream.readShort() ;
			mapVO.offsetY = stream.readShort() ;
			mapVO.xSpan = stream.readUnsignedByte() ;
			mapVO.zSpan = stream.readUnsignedByte() ;
			mapVO.gridData = new Grid(mapVO.xSpan,mapVO.zSpan);
			for( var i:int = 0 ; i<mapVO.xSpan ; ++i)
			{
				for( var j:int = 0 ; j<mapVO.zSpan ; ++j)
				{
					mapVO.gridData.setWalkable( i , j , stream.readBoolean() );
				}
			}
			return mapVO; 
		}
	}
}