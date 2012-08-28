package local.utils
{
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
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import local.game.cell.AnimObject;
	import local.vos.BitmapAnimResVO;
	
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
			this.cdns = Vector.<String>(["assets/"]); 
			this.maxLoadNum = 3 ;
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
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE , urlLoaderHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR , ioErrorHandler );
			urlLoader.load( new URLRequest( cdns[resVO.loadError]+resVO.url  ) );
		}
		
		
		override protected function urlLoaderHandler(e:Event):void
		{
			e.stopPropagation();
			var urlLoader:ResURLLoader = e.target as ResURLLoader ;
			var resVO:ResVO = _resDictionary[urlLoader.name] as ResVO ;
			if(resVO.extension.toLowerCase()=="bd"){
				urlLoader.removeEventListener(Event.COMPLETE , urlLoaderHandler);
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR , ioErrorHandler );
				var bytes:ByteArray = e.target.data as ByteArray;
				parseBuildingFile(bytes , resVO );
				
			}else{
				super.urlLoaderHandler(e);
			}
		}
		
		
		
		
		
		
		
		//========解析建筑资源==========================
		
		private function parseBuildingFile( bytes:ByteArray , resVO:ResVO  ):void
		{
			try{
				bytes.position = 0 ;
				bytes.uncompress();
			}
			catch(e:Error) { }
			finally
			{
				var gridX:int =  bytes.readUnsignedByte() ;
				var gridZ:int  =  bytes.readUnsignedByte() ;
				resVO.userData = { x:gridX , z:gridZ};
				var num:int = bytes.readUnsignedByte() ;
				var vo:BitmapAnimResVO ; 
				var bavos:Vector.<BitmapAnimResVO> = new Vector.<BitmapAnimResVO>( num , true );
				for( var i:int = 0 ; i<num ; ++i)
				{
					vo = new BitmapAnimResVO();
					if( bytes.readBoolean()){
						readAnimObject(vo ,bytes );
					}else{
						readRoadsLayerObject(vo ,bytes );
					}
					bavos[ i ] = vo ;
				}
				resVO.resObject = bavos ; 
				bytes.clear() ;
			}
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
		
		
		private static function readAnimObject( vo:BitmapAnimResVO , bytes:ByteArray ):void
		{
			vo.offsetX = bytes.readShort() ;
			vo.offsetY = bytes.readShort() ;
			
			var len:int = bytes.readUnsignedByte() ;
			vo.bmds = new Vector.<BitmapData>(len,true);
			var bmd:BitmapData ;
			var rect:Rectangle ;
			var pngBytes:ByteArray ;
			for( var j:int = 0 ; j<len ; ++j )
			{
				rect = new Rectangle(0,0 , bytes.readUnsignedShort() , bytes.readUnsignedShort());
				pngBytes = new ByteArray();
				bytes.readBytes( pngBytes, 0 , bytes.readDouble() );
				bmd = new BitmapData( rect.width , rect.height );
				bmd.setPixels( rect , pngBytes );
				vo.bmds[j] = bmd ;
			}
			
			vo.isAnim = bytes.readBoolean() ;
			if(vo.isAnim)
			{
				vo.row = bytes.readUnsignedByte() ;
				vo.col =bytes.readUnsignedByte() ; 
				vo.frame = bytes.readUnsignedByte() ;
				vo.rate = bytes.readUnsignedByte() ;
			}
		}
		
		private static function readRoadsLayerObject( vo:BitmapAnimResVO , bytes:ByteArray ):void
		{
			var len:int = bytes.readUnsignedByte() ;
			var p:Point ;
			vo.roads = new Vector.<Point>( len , true );
			for( var i:int = 0 ; i<len ; ++i )
			{
				p = new Point(bytes.readShort(),bytes.readShort());
				vo.roads[i] = p ;
			}
		}
		
	}
}