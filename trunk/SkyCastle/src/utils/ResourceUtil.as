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
			var groundGrid:Grid = new Grid(GameSetting.GRID_X , GameSetting.GRID_Z); //地面
			var buildingGrid:Grid = new Grid(GameSetting.GRID_X , GameSetting.GRID_Z); //建筑
			var roadGrid:Grid = AStarRoadGridModel.instance.roadGrid ;//寻路用的
			var bytes:ByteArray = resLoader as ByteArray;
			try
			{
				bytes.uncompress();
				for( var i:int = 0 ; i<GameSetting.GRID_X ; ++ i)
				{
					for( var j:int = 0 ; j<GameSetting.GRID_Z ; ++ j)
					{
						roadGrid.getNode(i,j).walkable = bytes.readBoolean() ;
					}
				}
				var bool:Boolean ;
				for(  i = 0 ; i<GameSetting.GRID_X ; ++ i)
				{
					for( j = 0 ; j<GameSetting.GRID_Z ; ++ j)
					{
						bool = bytes.readBoolean() ;
						groundGrid.getNode(i,j).walkable = bool;
						buildingGrid.getNode(i,j).walkable = bool ;
					}
				}
				resVO.resObject = new Object();
				resVO.resObject["groundGrid"]=groundGrid 
				resVO.resObject["buildingGrid"]=buildingGrid;
			}catch(e:Error){}
			
		}
	}
}