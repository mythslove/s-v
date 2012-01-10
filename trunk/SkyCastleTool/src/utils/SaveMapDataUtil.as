package utils
{
	import bing.iso.path.Grid;
	
	import comm.GameSetting;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import map.GameWorld;
	
	import models.MapDataModel;
	
	import mx.controls.Alert;

	public class SaveMapDataUtil
	{
		private var _file:File ;
		
		public function save():void
		{
			_file = new File();
			_file.addEventListener(Event.SELECT , selectedFileHandler );
			_file.browseForSave("保存");
		}
		private function selectedFileHandler(e:Event):void
		{
			_file.removeEventListener(Event.SELECT , selectedFileHandler );
			
			var fileStream:FileStream = new FileStream();
			fileStream.open( _file,FileMode.WRITE);
			try
			{
				var bytes:ByteArray = new ByteArray();
				for( var i:int = 0 ; i<GameSetting.GRID_X ; ++i)
				{
					for( var j:int = 0 ; j<GameSetting.GRID_Z ; ++j)
					{
						if(!GameWorld.instance.forbiddenScene.gridData.getNode(i,j).walkable)
						{
							bytes.writeByte( int(MapDataModel.instance.forbiddenHash[i+"-"+j].name) );
						}else{
							bytes.writeByte(0);
						}
					}
				}
				var size:int = MapDataModel.instance.impactHash.size();
				bytes.writeShort( size);
				var key:String ;
				for( i = 0 ; i<size; ++i )
				{
					key = MapDataModel.instance.impactHash.keys()[i] ;
					var nodex:int = int( key.substring(0,key.indexOf('-')) );
					var nodez:int = int( key.substring(key.indexOf('-')+1) );
					bytes.writeByte( nodex);
					bytes.writeByte( nodez);
				}
//				bytes.compress();
				bytes.position=0;
				fileStream.writeBytes( bytes,0,bytes.length );
				Alert.show("保存成功");
			}
			catch(e:Error)
			{
				
			}
			finally
			{
				fileStream.close();
			}
		}

	}
}