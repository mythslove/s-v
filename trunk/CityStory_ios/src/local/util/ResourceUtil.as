package local.util
{
	import bing.res.ResLoadedEvent;
	import bing.res.ResPool;
	import bing.res.ResType;
	import bing.res.ResURLLoader;
	import bing.res.ResVO;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import local.vo.BitmapAnimResVO;
	import local.vo.RoadResVO;
	
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
			this.cdns = Vector.<String>(["res/",""]); 
			this.maxLoadNum = 8 ;
			this.isRemote = false ;
		}
		public static function get instance():ResourceUtil
		{
			if(!_instance) _instance = new ResourceUtil();
			return _instance ;
		}
		//==================================
		/**
		 * key为资源名字，value为Vecter.<BitmapData>
		 */		
		private var _resNameHash:Dictionary = new Dictionary();
		
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
				parseLoadedBuilding(resVO , bytes );
			}
			else if(resVO.extension.toLowerCase()=="rd"){
				urlLoader.removeEventListener(Event.COMPLETE , urlLoaderHandler);
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR , ioErrorHandler );
				bytes = e.target.data as ByteArray;
				parseLoadedRoad( resVO , bytes );
			}
			else{
				super.urlLoaderHandler(e);
			}
		}
		
		
		
		
		//=======解析路/水=============================
		
		private var _directions:Array = ["","_L","_R","_U","_B","_M","_LU","_LB","_RU","_RB","_LU_M","_LB_M","_RU_M","_RB_M","_LM","_RM"];
		/**解析路资源文件 */
		public function parseRoadFile(  resVO:ResVO , bytes:ByteArray ):void
		{
			try{
				bytes.position = 0 ;
				bytes.uncompress();
			}
			catch(e:Error){}
			finally
			{
				var roadResVO:RoadResVO =new RoadResVO();
				var num:int = bytes.readUnsignedByte() ; //路块的数量
				for( var i:int = 0 ; i<num ; ++i)
				{
					roadResVO.offsetXs[ resVO.resId+_directions[i] ] = bytes.readShort();
					roadResVO.offsetYs[ resVO.resId+_directions[i] ] = bytes.readShort();
					var rect:Rectangle = new Rectangle(0,0 , bytes.readUnsignedShort() , bytes.readUnsignedShort());
					var pngBytes:ByteArray =new ByteArray();
					bytes.readBytes( pngBytes, 0 , bytes.readDouble() );
					var bmd:BitmapData = new BitmapData( rect.width , rect.height );
					bmd.setPixels( rect , pngBytes );
					roadResVO.bmds[ resVO.resId+_directions[i] ] = bmd ;
				}
				bytes.clear();
				resVO.resObject = roadResVO ;
			}
			_resDictionary[ resVO.resId ] = resVO ;
		}
		
		//解析下载完成的的路资源文件 
		private function parseLoadedRoad( resVO:ResVO , bytes:ByteArray ):void
		{
			parseRoadFile(resVO,bytes);
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
		
		
		
		//========解析建筑资源==========================
		
		/** 解析建筑资源和动画资源文件 */
		public function parseAnimFile( resVO:ResVO , bytes:ByteArray ):void
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
			_resDictionary[ resVO.resId ] = resVO ;
		}
		
		//解析下载完成下来的建筑资源文件 
		private function parseLoadedBuilding( resVO:ResVO ,bytes:ByteArray ):void
		{
			parseAnimFile(resVO,bytes);
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
		
		
		private function readAnimObject( vo:BitmapAnimResVO , bytes:ByteArray ):void
		{
			vo.offsetX = bytes.readShort() ;
			vo.offsetY = bytes.readShort() ;
			vo.scaleX = bytes.readFloat();
			vo.scaleY = bytes.readFloat();
			vo.resName = bytes.readUTF();
			vo.resName = vo.resName.substring(0,vo.resName.indexOf(".")) ;
			
			var exsit:Boolean;
			if(vo.resName){
				exsit =  _resNameHash.hasOwnProperty(vo.resName) ;
				if(exsit) vo.bmds = _resNameHash[vo.resName] as Vector.<BitmapData> ;
			}
			var len:int = bytes.readUnsignedByte() ;
			if(!exsit) vo.bmds = new Vector.<BitmapData>(len,true);
			var bmd:BitmapData ;
			var rect:Rectangle ;
			var pngBytes:ByteArray ;
			for( var j:int = 0 ; j<len ; ++j )
			{
				rect = new Rectangle(0,0 , bytes.readUnsignedShort() , bytes.readUnsignedShort());
				pngBytes = new ByteArray();
				bytes.readBytes( pngBytes, 0 , bytes.readDouble() );
				if(!exsit) {
					bmd = new BitmapData( rect.width , rect.height );
					bmd.setPixels( rect , pngBytes );
					vo.bmds[j] = bmd ;
				}
			}
			
			vo.isAnim = bytes.readBoolean() ;
			if(vo.isAnim)
			{
				vo.row = bytes.readUnsignedByte() ;
				vo.col =bytes.readUnsignedByte() ; 
				vo.frame = bytes.readUnsignedByte() ;
				vo.rate = bytes.readUnsignedByte() ;
			}
			if(!exsit) {
				_resNameHash[vo.resName]  = vo.bmds ;
			}
		}
		
		private function readRoadsLayerObject( vo:BitmapAnimResVO , bytes:ByteArray ):void
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