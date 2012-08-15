package game.mvc.model
{
	import bing.ds.HashMap;
	import bing.utils.SystemUtil;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import game.elements.ground.Block;
	import game.events.ChangeMapEvent;
	import game.events.LoadMapEvent;
	import game.global.Constants;
	import game.global.GameData;
	import game.global.GameEngine;
	import game.mvc.base.GameModel;
	import game.mvc.model.vo.MapVO;
	import game.utils.AstarFindPath2Util;
	import game.utils.AstarFindPathUtil;
	
	import org.blch.findPath.Cell;
	import org.blch.geom.Triangle;
	import org.blch.geom.Vector2f;
	import game.init.ConfigXMLInit;

	/**
	 * 所有的地图数据，以及当前地图数据和配置文件
	 * 包括碰撞，网格坐标点
	 * @author zhouzhanglin
	 */	
	public class MapDataModel extends GameModel
	{
		private static var _instance:MapDataModel;
		public static function get instance():MapDataModel
		{
			if(!_instance) _instance = new MapDataModel();
			return _instance ;
		}
		//====================================
		
		public var defaultMapId:int =1 ; //默认的地图id
		public var serachRoadType:int =3 ; //寻路方式 
		public var cellV:Vector.<Cell> ; //网格数据，用于寻路用
		public var bigMap:Bitmap ; //如果不分块加载，才有大地图
		public var miniMap:Bitmap ; //小地图
		public var currentMapVO:MapVO ; //当前地图
		public var mapDataHash:HashMap ; //地图的数据Hash
		public var mapBlocks:Vector.<Block> ; //地图分块的所有块
		
		private var _mapsHash:HashMap = new HashMap(); //key为id , value为mapVO
		private var _config:XML ;
		private var _loader:Loader ;
		private var _urlLoader:URLLoader ;
		private var _mapConfig:XML ; //地图配置文件
		private var _mapData:ByteArray; //地图二进制数据
		
		
		/**
		 *  解析configXML
		 */		
		public function parseConfigXML( configXML:XML ):void
		{
			_config =configXML ;
			defaultMapId = int( _config.maps[0].defaultMap); //默认的地图
			serachRoadType = int( _config.maps[0].searchRoadType) ; //寻路的方式
			var mapVOXML:* = _config.maps[0].mapVO ;
			const LEN:int = mapVOXML.length();
			var mapVO:MapVO ;
			for ( var i:int=0 ; i <LEN ; i++)
			{
				mapVO = new MapVO();
				mapVO.id = int( mapVOXML[i].@id );
				mapVO.url=String(mapVOXML[i].@url );
				_mapsHash.put( mapVO.id , mapVO );
			}
		}
		/**
		 *  获取地图配置
		 */		
		public function getMapVO( mapId:int ):MapVO
		{
			return _mapsHash.getValue( mapId ) as MapVO ;
		}
		
		private function createCell( triangleV:Vector.<Triangle> ):void
		{
			cellV = new Vector.<Cell>();
			var trg:Triangle;
			var cell:Cell;
			for (var j:int=0; j<triangleV.length; j++) {
				trg = triangleV[j];
				cell = new Cell(trg.getVertex(0), trg.getVertex(1), trg.getVertex(2));
				cell.index = j ;
				cellV.push(cell) ;
			}
			//搜索单元网格的邻接网格,并保存链接数据到网格中,以提供给寻路用
			for each (var pCellA:Cell in cellV) {
				for each (var pCellB:Cell in cellV) {
					if (pCellA != pCellB) {
						pCellA.checkAndLink(pCellB);
					}
				}
			}
		}
		
		//==============================================
		//============加载一张地图==========================
		
		private var _step:int ; //加载步骤
		
		public function loadMap( mapId:int ):void
		{
			this.clear() ;
			currentMapVO = this.getMapVO( mapId );
			loadMapConfig();
		}
		
		//加载此地图的配置文件
		private function loadMapConfig():void
		{
			_step = 1 ;
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = URLLoaderDataFormat.BINARY ;
			_urlLoader.addEventListener(Event.COMPLETE , loadMapCompleteHandler );
			_urlLoader.addEventListener( ProgressEvent.PROGRESS , loadMapProgressHandler );
			_urlLoader.load( new URLRequest(GameData.baseURL+currentMapVO.url+"mapConfig.xml"));
		}
		
		//加载小地图
		private function loadMiniMap():void
		{
			_step = 2 ;
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE , loadMapCompleteHandler );
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS , loadMapProgressHandler );
			_loader.load( new URLRequest(GameData.baseURL+currentMapVO.url+"miniMap.jpg"));
		}
		
		//加载地图数据
		private function loadMapBing():void
		{
			_step = 3 ;
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = URLLoaderDataFormat.BINARY ;
			_urlLoader.addEventListener(Event.COMPLETE , loadMapCompleteHandler );
			_urlLoader.addEventListener( ProgressEvent.PROGRESS , loadMapProgressHandler );
			_urlLoader.load( new URLRequest(GameData.baseURL+currentMapVO.url+"map.bing"));
		}
		
		//加载大地图
		private function loadBigMap():void
		{
			_step = 4 ;
			if(currentMapVO.segmentation){
				createBlocks();
				//切换地图完成
				this.dispatchContextEvent( new ChangeMapEvent( ChangeMapEvent.CHANGE_MAP_OVER) );
				GameEngine.instance.start() ;
			}else{
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE , loadMapCompleteHandler );
				_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS , loadMapProgressHandler );
				_loader.load( new URLRequest(GameData.baseURL+currentMapVO.url+"background.jpg"));
			}
		}
		
		//创建地块
		private function createBlocks():void 
		{
			mapBlocks = new Vector.<Block>(true,row*col);
			var row:int = Math.ceil(currentMapVO.mapHeight/currentMapVO.segH) ;
			var col:int = Math.ceil( currentMapVO.mapWidth/currentMapVO.segW) ;
			var rect:Rectangle
			var block:Block ;
			var count:int =0;
			for( var i:int = 0 ; i<row ; i++)
			{
				for(var j:int = 0 ; j<col ; j++)
				{
					rect = new Rectangle(0,0, currentMapVO.segW, currentMapVO.segH); 
					rect.x = j*currentMapVO.segW ;
					rect.y = i*currentMapVO.segH ;
					
					if(rect.x+currentMapVO.segW>currentMapVO.mapWidth){
						rect.width=currentMapVO.mapWidth-rect.x ;
					}else{
						rect.width = currentMapVO.segW ;
					}
					if(rect.y+currentMapVO.segH>currentMapVO.mapHeight){
						rect.height=currentMapVO.mapHeight-rect.y ;
					}else{
						rect.height = currentMapVO.segH ;
					}
					block = new Block(rect );
					block.name=i+"-"+j;
					mapBlocks[count] = block ;
					count++;
				}
			}
		}
		
		private function loadMapCompleteHandler(e:Event):void
		{
			e.stopPropagation() ;
			e.target.removeEventListener(Event.COMPLETE , loadMapCompleteHandler );
			e.target.removeEventListener( ProgressEvent.PROGRESS , loadMapProgressHandler );
			if(_step==1){
				var data:ByteArray=e.target.data as ByteArray ;
				try{
					data.uncompress();
				}catch(e:Error){
					SystemUtil.debug(currentMapVO.alias+": mapConfig	未压缩");
				}
				_mapConfig=XML(data.toString());
				parseMapConfig(); //解析地图配置
				loadMiniMap(); //加载小地图图片
			}
			else if(_step==2)
			{
				miniMap = _loader.content as Bitmap ;
				loadMapBing() ;//加载地图数据
			}
			else if(_step==3)
			{
				_mapData=e.target.data as ByteArray ;
				try{
					_mapData.uncompress();
				}catch(e:Error){
					SystemUtil.debug(currentMapVO.alias+": map.bing未压缩");
				}
				parseMapBing() ;  //解析地图数据
				loadBigMap() ; //加载大地图
			}
			else if(_step==4)
			{
				bigMap = _loader.content as Bitmap ;
				//地图加载完成
				this.dispatchContextEvent( new LoadMapEvent(LoadMapEvent.MAP_LOAED)) ;
				//切换地图完成
				this.dispatchContextEvent( new ChangeMapEvent( ChangeMapEvent.CHANGE_MAP_OVER) );
				GameEngine.instance.start() ;
			}
 		}
		
		private function loadMapProgressHandler(e:ProgressEvent):void
		{
			e.stopPropagation() ;
			var evt:LoadMapEvent = new LoadMapEvent( LoadMapEvent.MAP_LOADING_PROGERSS);
			evt.currentStep=_step ;
			evt.totalStep = 4 ;
			evt.progress = e.bytesLoaded/e.bytesTotal;
			switch(_step){
				case 1:
					evt.info="加载配置文件";
					break ;
				case 2:
					evt.info="加载小地图";
					break
				case 3:
					evt.info="加载地图数据";
					break;
				case 4:
					evt.info="加载大地图";
					break ;
			}
			this.dispatchContextEvent( evt );
		}
		
		//解析地图配置文件
		private function parseMapConfig():void
		{
			currentMapVO.alias = String(_mapConfig.map[0].alias ) ;
			currentMapVO.mapName = String(_mapConfig.map[0].mapName ) ;
			currentMapVO.tileWidth = int(_mapConfig.map[0].tileWidth ) ;
			currentMapVO.tileHeight = int(_mapConfig.map[0].tileHeight ) ;
			currentMapVO.segW = int(_mapConfig.map[0].segW ) ;
			currentMapVO.segH = int(_mapConfig.map[0].segH ) ;
			currentMapVO.rowCount = int(_mapConfig.map[0].rowCount ) ;
			currentMapVO.colCount = int(_mapConfig.map[0].colCount ) ;
			currentMapVO.mapWidth = int(_mapConfig.map[0].mapWidth ) ;
			currentMapVO.mapHeight = int(_mapConfig.map[0].mapHeight ) ;
			currentMapVO.segmentation =_mapConfig.map[0].segmentation=="true" ?true:false ;
			currentMapVO.segRow = Math.ceil(currentMapVO.mapHeight/currentMapVO.segH) ;
			currentMapVO.segCol =  Math.ceil( currentMapVO.mapWidth/currentMapVO.segW );
			currentMapVO.scale = int(_mapConfig.map[0].scale ) ;
			//解析地图上的一些npc，建筑，特效等
			MapItemsModel.instance.parseMapConfig( _mapConfig );
		}
		
		//解析地图数据
		private function parseMapBing():void
		{
			mapDataHash = new HashMap();
			var impactArray:Array = new Array();
			//路点
			for(var i:int = 0 ; i<currentMapVO.colCount ; i++)
			{
				for(var j:int = 0 ; j<currentMapVO.rowCount*2-1 ; j++)
				{
					var temp:int = _mapData.readUnsignedByte() ;
					mapDataHash.put(i+"-"+j ,temp );
					//如果是寻路方式不是网格寻路方式，获取碰撞数据
					if(this.serachRoadType!=Constants.SEARCH_ROAD_TYPE_MESH )
					{
						if(temp==Constants.MAPDATA_TYPE_IMPACT){
							impactArray[j+"-"+i] =  true ;
						}else{
							impactArray[j+"-"+i] =  false ;
						}
					}
				}
			}
			if(this.serachRoadType==Constants.SEARCH_ROAD_TYPE_MESH)
			{
				//三角形网格
				const len:uint = _mapData.readUnsignedShort();
				var triangle:Triangle;
				var triangleV:Vector.<Triangle>= new Vector.<Triangle>(len,true);
				for( i = 0 ; i<len ; i++)
				{
					triangle = new Triangle(new Vector2f(_mapData.readUnsignedShort(),_mapData.readUnsignedShort()),
						new Vector2f(_mapData.readUnsignedShort(),_mapData.readUnsignedShort()),
						new Vector2f(_mapData.readUnsignedShort(),_mapData.readUnsignedShort()));
					triangleV[i] = triangle ;
				}
				this.createCell( triangleV );
			}
			else if(this.serachRoadType==Constants.SEARCH_ROAD_TYPE_ASTAR1)
			{
				new AstarFindPath2Util( currentMapVO.tileWidth,currentMapVO.tileHeight,currentMapVO.rowCount,currentMapVO.colCount*2-1,impactArray);
				new AstarFindPathUtil( currentMapVO.tileWidth,currentMapVO.tileHeight,currentMapVO.rowCount,currentMapVO.colCount*2-1,impactArray);
			}
			else if(this.serachRoadType==Constants.SEARCH_ROAD_TYPE_ASTAR)
			{
				new AstarFindPathUtil( currentMapVO.tileWidth,currentMapVO.tileHeight,currentMapVO.rowCount,currentMapVO.colCount*2-1,impactArray);
			}
			//解析地图数据完成
			_mapData = null ;
		}
		
		//先将上次的数据清空
		private function clear():void
		{
			//释放 小地图图片
			if(miniMap) miniMap.bitmapData.dispose() ;
			miniMap = null ;
			//释放大地图图片
			if(bigMap) bigMap.bitmapData.dispose() ;
			bigMap = null ;
			//清除上一张的地图数据
			if(mapDataHash) mapDataHash.clear();
			mapDataHash = null ;
			//清除地图块
			if(mapBlocks) 
			{
				for each( var block:Block in mapBlocks)
				{
					block.dispose() ;
					block =null ;
				}
				mapBlocks=null ;
			}
			mapDataHash = null ;
			//成员属性
			currentMapVO = null ;
			cellV = null ;
			_loader = null ;
			_urlLoader = null ;
			_mapData = null ;
		}
	}
}