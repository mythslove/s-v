package local.utils
{
	import bing.animation.AnimationBitmap;
	import bing.iso.path.Grid;
	import bing.res.ResPool;
	import bing.res.ResType;
	import bing.res.ResVO;
	import bing.utils.SystemUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import local.comm.GameSetting;
	import local.model.MapGridDataModel;
	
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
		override protected function handleRes(resVO:ResVO, resLoader:Object):void
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
					if( resVO.resId=="init_mapdata"){
						parseMapData( resVO , resLoader );
					}else{
						resVO.resObject = resLoader ;
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
			var bytes:ByteArray = resLoader as ByteArray;
			try
			{
				bytes.uncompress();
			}
			catch(e:Error)
			{
				SystemUtil.debug("地图配置没有压缩");
			}
			var temp:int ;
			for( var i:int = 0 ; i<GameSetting.GRID_X ; ++ i)
			{
				for( var j:int = 0 ; j<GameSetting.GRID_Z ; ++ j)
				{
					temp = bytes.readUnsignedByte();
					//哪个isoScene索引
					MapGridDataModel.instance.sceneHash[i+"-"+j]=temp;
					if(temp>0){
						//大于表示这里可以放建筑，所以寻路和建筑，地面数据都需要这些数据
						MapGridDataModel.instance.astarGrid.getNode(i,j).walkable = true ;
						MapGridDataModel.instance.buildingGrid.getNode(i,j).walkable = true ;
						MapGridDataModel.instance.groundGrid.getNode(i,j).walkable = true ;
					}
				}
			}
			temp = bytes.readUnsignedShort();
			for(  i = 0 ; i<temp ; ++ i)
			{
				//额外的格子，如楼梯，这里寻路需要这些数据，但建筑不需要这些格子
				var nodeX:int = bytes.readUnsignedByte() ;
				var nodeZ:int = bytes.readUnsignedByte() ;
				MapGridDataModel.instance.astarGrid.getNode(nodeX,nodeZ).walkable = true ;
				MapGridDataModel.instance.extraHash[nodeX+"-"+nodeZ] = true ;
			}
		}
	}
}