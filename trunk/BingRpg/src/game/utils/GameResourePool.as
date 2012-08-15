package game.utils
{
	import bing.res.ReflectType;
	import bing.res.ResPool;
	import bing.res.ResType;
	import bing.res.ResVO;
	import bing.utils.SystemUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.utils.getDefinitionByName;
	
	import game.global.GameData;
	
	/**
	 * 游戏资源库 
	 * @author zhouzhanglin
	 */	
	public class GameResourePool extends ResPool
	{
		private static var _instance:GameResourePool; 
		
		public function GameResourePool()
		{
			if(_instance){
				throw new Error("重复实例化");
			}
			this.cdns = Vector.<String>([""]);
		}
		
		public static function get instance():GameResourePool
		{
			if(!_instance) _instance = new GameResourePool();
			return _instance ;
		}
		//==================================
		
		override public function loadRes(resVO:ResVO):void
		{
			resVO.url=GameData.baseURL+resVO.url ;
			super.loadRes(resVO);
		}
		
		override protected function handleRes(resVO:ResVO, resLoader:Object):void
		{
			SystemUtil.debug(resVO.name+"下载完成");
			switch(resVO.resType)
			{
				case ResType.SWF :
					if(resVO.reflectType==ReflectType.BITMAPDATA)
					{
						var bmds:Vector.<BitmapData> = new Vector.<BitmapData>( resVO.num , true );
						for( var i:int = 0 ; i<resVO.num ; i++)
						{
							bmds[i] =new (getDefinitionByName(resVO.name+"_"+i) as Class)() as BitmapData ;
						}
						resVO.resObject = bmds ;
						resLoader.unloadAndStop();
						resLoader = null ;
					}
					else
					{
						resVO.resObject = resLoader ;
					}
					break ;
				case ResType.IMG :
					resVO.resObject = resLoader.contentLoaderInfo.content as Bitmap ;
					resLoader.unloadAndStop();
					break ;
			}
		}
	}
}