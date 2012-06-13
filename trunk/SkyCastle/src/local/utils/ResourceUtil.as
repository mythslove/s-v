package local.utils
{
	import bing.animation.AnimationBitmap;
	import bing.iso.path.Grid;
	import bing.res.ResLoadedEvent;
	import bing.res.ResPool;
	import bing.res.ResType;
	import bing.res.ResURLLoader;
	import bing.res.ResVO;
	import bing.utils.SystemUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import local.comm.GameData;
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
			//http://www.developbbs.com/res/sc/ 远程
			this.cdns = Vector.<String>(["../"]); 
			this.maxLoadNum = 6 ;
		}
		public static function get instance():ResourceUtil
		{
			if(!_instance) _instance = new ResourceUtil();
			return _instance ;
		}
		//==================================
		
		/**
		 * 下载一个资源 
		 * @param resVO
		 */		
		override protected function loadAResource( resVO:ResVO ):void
		{
			switch(resVO.resType)
			{
				case ResType.SWF:
				case ResType.TEXT:
				case ResType.BINARY:
					urlLoaderARes( resVO );
					break ;
				default:
					loaderARes(resVO);
					break ;
			}
		}
		override protected function urlLoaderARes(resVO:ResVO):void
		{
			var urlLoader:ResURLLoader = new ResURLLoader();
			urlLoader.name = resVO.resId ;
			if(resVO.resType==ResType.BINARY || resVO.resType==ResType.SWF){
				urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			}
			urlLoader.addEventListener(Event.COMPLETE , urlLoaderHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR , ioErrorHandler );
			urlLoader.load( new URLRequest( cdns[resVO.loadError]+resVO.url  ) );
		}
		
		override protected function urlLoaderHandler(e:Event):void
		{
			e.stopPropagation();
			var urlLoader:ResURLLoader = e.target as ResURLLoader ;
			var resVO:ResVO = _resDictionary[urlLoader.name] as ResVO ;
			if(resVO.resType==ResType.SWF){
				urlLoader.removeEventListener(Event.COMPLETE , urlLoaderHandler);
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR , ioErrorHandler );
				var bytes:ByteArray = e.target.data as ByteArray;
				var newBytes:ByteArray = new ByteArray();
				var key:int = bytes.readByte()==1 ? key =1 : 0 ;
				newBytes.writeBytes(bytes,key);
				newBytes.position =0 ;
				var loader:Loader = new Loader();
				loader.name = resVO.resId ;
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE , swfBytesLoadedHandler );
				loader.loadBytes(newBytes ,new LoaderContext(false,ApplicationDomain.currentDomain));
				if(key==0){
					SystemUtil.debug( resVO.resId +".swf没有加密");
				}
			}else{
				super.urlLoaderHandler(e);
			}
		}
		private function swfBytesLoadedHandler( e:Event ):void
		{
			var loader:Loader  = e.target.loader as Loader ;
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE , swfBytesLoadedHandler );
			var resVO:ResVO = _resDictionary[loader.name] as ResVO ;
			resVO.resObject = loader ;
			//抛出资源加载完成事件
			var resLoadedEvent:ResLoadedEvent = new ResLoadedEvent(resVO.resId);
			resLoadedEvent.resVO = resVO ;
			this.dispatchEvent( resLoadedEvent );
			_currentLoadNum--;
			//下载下一个
			if( _loadList.length>0 )
			{
				resVO = _loadList.shift() ;
				loadAResource( resVO );
			}
		}
		
		
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
					if( resVO.resId==GameData.currentMapId+"_DATA"){
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