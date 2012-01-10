package utils
{
	import bing.animation.AnimationBitmap;
	import bing.iso.path.Grid;
	import bing.res.ResPool;
	import bing.res.ResType;
	import bing.res.ResVO;
	
	import comm.GameSetting;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import models.AStarRoadGridModel;
	
	/**
	 * 游戏资源加载和保存以及处理的管理类 
	 * @author zhouzhanglin
	 */	
	public class ResourceUtil extends ResPool
	{
		private static var _instance:ResourceUtil; 
		
		public function ResourceUtil()
		{
			if(_instance){
				throw new Error("重复实例化");
			}
			this.cdns = Vector.<String>(["../"]);
			this.maxLoadNum = 5 ;
		}
		public static function get instance():ResourceUtil
		{
			if(!_instance) _instance = new ResourceUtil();
			return _instance ;
		}
		//==================================
		/**
		 * 处理加载完成的资源 
		 * @param resVO 
		 * @param resLoader 加载完成的数据
		 */		
		override protected function handleRes(resVO:ResVO , resLoader:Object):void
		{
			switch(resVO.resType)
			{
				case ResType.IMG :
					var bmd:BitmapData= (resLoader.contentLoaderInfo.content as Bitmap).bitmapData;
					if(resVO.frames>1){
						resVO.resObject = AnimationBitmap.splitBitmap( bmd,resVO.row,resVO.col,resVO.frames);
					}else{
						resVO.resObject = bmd ;
					}
					resLoader.unloadAndStop();
					break ;
				case ResType.BINARY:
					if( resVO.name=="mapdata"){
						parseMapData( resVO , resLoader );
					}
					break ;
				default:
					resVO.resObject = resLoader ;
					break;
			}
		}
		
		/**
		 * 解析地图数据 
		 * @param resVO
		 * @param resLoader
		 */		
		private function parseMapData( resVO:ResVO , resLoader:Object ):void
		{
			var groundGrid1:Grid = new Grid(GameSetting.GRID_X , GameSetting.GRID_Z); //地面1
			var buildingGrid1:Grid = new Grid(GameSetting.GRID_X , GameSetting.GRID_Z); //建筑1
			var groundGrid2:Grid = new Grid(GameSetting.GRID_X , GameSetting.GRID_Z); //地面2
			var buildingGrid2:Grid = new Grid(GameSetting.GRID_X , GameSetting.GRID_Z); //建筑2
			var groundGrid3:Grid = new Grid(GameSetting.GRID_X , GameSetting.GRID_Z); //地面3
			var buildingGrid3:Grid = new Grid(GameSetting.GRID_X , GameSetting.GRID_Z); //建筑3
			var roadGrid:Grid = AStarRoadGridModel.instance.roadGrid ;//寻路用的数据
			var bytes:ByteArray = resLoader as ByteArray;
			try
			{
				bytes.uncompress();
				var temp:int ;
				for( var i:int = 0 ; i<GameSetting.GRID_X ; ++ i)
				{
					for( var j:int = 0 ; j<GameSetting.GRID_Z ; ++ j)
					{
						temp = bytes.readUnsignedByte();
						if(temp>0){
							roadGrid.getNode(i,j).walkable = true ;
						}
						switch(temp)
						{
							case 1:
								groundGrid1.getNode(i,j).walkable=true ;
								buildingGrid1.getNode(i,j).walkable=true ;
								break ;
							case 2:
								groundGrid2.getNode(i,j).walkable=true ;
								buildingGrid2.getNode(i,j).walkable=true ;
								break ;
							case 3:
								groundGrid3.getNode(i,j).walkable=true ;
								buildingGrid3.getNode(i,j).walkable=true ;
								break ;
						}
					}
				}
				temp = bytes.readUnsignedShort();
				for(  i = 0 ; i<temp ; ++ i)
				{
					roadGrid.getNode(bytes.readUnsignedByte(),bytes.readUnsignedByte()).walkable = true ;
				}
	
				var obj:Object = new Object();
				obj["groundGrid1"]=groundGrid1 ;
				obj["buildingGrid1"]=buildingGrid1;
				obj["groundGrid2"]=groundGrid2 ;
				obj["buildingGrid2"]=buildingGrid2;
				obj["groundGrid3"]=groundGrid3 ;
				obj["buildingGrid3"]=buildingGrid3;
				resVO.resObject = obj ;
			}catch(e:Error){trace(e);}
			
		}
	}
}