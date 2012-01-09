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
				wirteGrid(GameWorld.instance.impactScene.gridData,bytes);
				wirteGrid(GameWorld.instance.forbiddenScene.gridData,bytes);
				bytes.compress();
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
		
		private function wirteGrid( grid:Grid , bytes:ByteArray ):void
		{
			for( var i:int = 0 ; i<GameSetting.GRID_X ; ++i)
			{
				for( var j:int = 0 ; j<GameSetting.GRID_Z ; ++j)
				{
					if(grid.getNode(i,j).walkable)
					{
						bytes.writeBoolean(true);
					}else{
						bytes.writeBoolean(false);
					}
				}
			}
		}
	}
}