package utils
{
	import bing.iso.IsoObject;
	import bing.iso.IsoScene;
	import bing.iso.Rhombus;
	import bing.iso.path.Grid;
	
	import comm.GameData;
	import comm.GameSetting;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import map.GameWorld;
	
	import models.MapDataModel;

	public class ReadMapDataUtil
	{
		private var _file:File ;
		public function read():void
		{
			_file = new File();
			_file.addEventListener(Event.SELECT , selectedFileHandler);
			_file.browseForOpen("选择地图数据");
		}
		
		private function selectedFileHandler(e:Event):void
		{
			_file.removeEventListener(Event.SELECT , selectedFileHandler);
			var fileStream:FileStream = new FileStream();
			try
			{
				fileStream.open( _file,FileMode.READ );
				var bytes:ByteArray = new ByteArray();
				fileStream.readBytes( bytes , 0 , fileStream.bytesAvailable );
				bytes.uncompress();
				
				for(var i:int = 0 ; i <GameSetting.GRID_X ; ++i)
				{
					for( var j:int = 0 ; j<GameSetting.GRID_Z ; ++j)
					{
						var flag:int = bytes.readByte();
						if(flag>0)
						{
							var color:uint = 0;
							switch(flag)
							{
								case 1:
									color=GameSetting.Map1Color ;
									break ;
								case 2:
									color=GameSetting.Map2Color ;
									break ;
								case 3:
									color=GameSetting.Map3Color ;
									break ;
							}
							var obj:IsoObject = new IsoObject(GameSetting.GRID_SIZE,1,1);
							obj.name=flag+"";
							obj.addChild( new Rhombus(GameSetting.GRID_SIZE , color));
							obj.nodeX = i ;
							obj.nodeZ = j ;
							obj.setWalkable( false , GameWorld.instance.forbiddenScene.gridData );
							MapDataModel.instance.addForbidden( obj.nodeX , obj.nodeZ , obj );
							GameWorld.instance.forbiddenScene.addIsoObject( obj , false );
						}
					}
				}
				var num:int = bytes.readUnsignedShort()
				for(i = 0 ; i <num ;++i)
				{
					var nodex:int = bytes.readUnsignedByte() ;
					var nodez:int = bytes.readUnsignedByte() ;
					
					obj = new IsoObject(GameSetting.GRID_SIZE,1,1);
					obj.addChild( new Rhombus(GameSetting.GRID_SIZE , 0xffcc00));
					obj.nodeX = nodex ;
					obj.nodeZ = nodez ;
					obj.setWalkable( false , GameWorld.instance.impactScene.gridData );
					MapDataModel.instance.addImpact( obj.nodeX , obj.nodeZ , obj );
					GameWorld.instance.impactScene.addIsoObject(obj , false );
				}
			}
			catch(e:Error){}
			finally
			{
				fileStream.close() ;
			}
		}
		
	}
}