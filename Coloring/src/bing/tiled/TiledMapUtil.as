package bing.tiled
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	[Event(name="complete",type="flash.events.Event")]
	[Event(name="progress",type="flash.events.ProgressEvent")]
	public class TiledMapUtil extends EventDispatcher
	{
		private static var _instance:TiledMapUtil;
		public function TiledMapUtil()
		{
			if(_instance) throw new Error("error");
		}
		public static function get instance():TiledMapUtil
		{
			if(!_instance) _instance = new TiledMapUtil();
			return _instance ;
		}
		
		//=============================parse xml
		
		private var _config:XML ;
		private var _urlLoader:URLLoader ;
		private var _map:Map ;
		private var _resLoader:TiledLoader ;
		
		public function loadMap(tmx:String):void
		{
			disposeMap();
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = URLLoaderDataFormat.BINARY ;
			_urlLoader.addEventListener(Event.COMPLETE , loadedConfig );
			_urlLoader.load( new URLRequest(tmx) );
		}
		
		private function loadedConfig(e:Event):void
		{
			_urlLoader.removeEventListener(Event.COMPLETE , loadedConfig );
			var byte:ByteArray = e.target.data ;
			
			try { byte.uncompress() ;}
			catch(e:Error){}
			finally { _config = XML( byte.toString() ); }
			
			parseXML();
			loadRes();
		}
		
		private function parseXML():void 
		{
			_map = new Map();
			
			_map.orientation = String(_config.@orientation);
			_map.row = int(_config.@width);
			_map.col = int(_config.@height);
			_map.tilewidth = int(_config.@tilewidth);
			_map.tileheight = int(_config.@tileheight);
			
			
			var tilesetXML:* = _config.tileset ;
			var tileset:Tileset ;
			for( var i:int = 0 ; i<tilesetXML.length() ; i ++)
			{
				tileset = new Tileset();
				tileset.firstgrid = int(tilesetXML[i].@firstgid);
				tileset.margin =  int(tilesetXML[i].@margin);
				tileset.spacing =  int(tilesetXML[i].@spacing);
				tileset.tilewidth =  int(tilesetXML[i].@tilewidth);
				tileset.tileheight =  int(tilesetXML[i].@tileheight);
				tileset.name =  String(tilesetXML[i].@name);
				tileset.imgUrl = new Vector.<String>();
				tileset.imgUrl=String(tilesetXML[i].image[0].@source) ;
				
				var tileXML:*  = tilesetXML[i].tile ;
				tileset.tiles=new Vector.<Tile>();
				var tile:Tile;
				for(var j:int=0 ; j<tileXML.length() ; j++ )
				{
					tile = new Tile();
					tile.id = int( tileXML[j].@id );
					var propXML:* =  tileXML[j].properties[0].property ;
					for( var k:int = 0 ; k<propXML.length(); k++)
					{
						if(!tile.prop) tile.prop =new Dictionary();
						tile.prop[ String(propXML[k].@name) ] = String( propXML[k].@value );
					}
					tileset.tiles.push( tile );
					if( !_map.tilesDic)  _map.tilesDic= new Dictionary();
					_map.tilesDic[tile.id] = tile ;
				}
				
				_map.tilesets.push(tileset);
			}
			
			var layerXML:* = _config.layer ;
			_map.layerCount = layerXML.length() ;
			var layer:Layer ;
			for( i =  0; i<layerXML.length() ; i++)
			{
				layer = new Layer();
				layer.index = i ; 
				layer.name = String(layerXML[i].@name);
				layer.width = int( layerXML[i].@width );
				layer.height = int( layerXML[i].@height );
				
				var tep:Array = String( layerXML[i].data[0]+",").split("\n") ;
				layer.data = getGridData( layer.width , layer.height ,  tep );
				_map.layers.push( layer);
			}
			
		}
		
		private function getGridData(width:int , height:int , data:Array ):Vector.<Vector.<int>>
		{
			const LEN:int = data.length ;
			var temp:Vector.<Vector.<int>> = new Vector.<Vector.<int>>(LEN,true);
			var rowArray:Array ;
			for(var i:int = 0 ; i<LEN ; i++)
			{
				temp[i] = new Vector.<int>(width,true);
				rowArray = String(data[i]).split(",") ;
				for( var j:int = 0 ; j<rowArray.length-1 ; j++)
				{
					temp[i][j] = int(rowArray[j]) ;
				}
			}
			return temp ;
		}
		
		private function loadRes():void 
		{
			_resLoader = new TiledLoader(_map.tilesets);
			_resLoader.addEventListener(Event.COMPLETE , resLoaded);
			_resLoader.addEventListener(ProgressEvent.PROGRESS , resPro );
			_resLoader.load() ;
		}
		
		private function resLoaded( e:Event ):void
		{
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function resPro(e:ProgressEvent):void 
		{
			var proEvt:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
			proEvt.bytesLoaded = e.bytesLoaded;
			proEvt.bytesTotal =e.bytesTotal ;
			this.dispatchEvent( proEvt);
		}
		
		//================================== get userfull data
		
		public function get map():Map
		{
			return _map ;
		}
		
		/**
		 *  获取tile
		 * @param rowIndex 行索引
		 * @param colIndex 列索引
		 * @param layer
		 * @return 
		 * 
		 */		
		public function getTile( rowIndex:int , colIndex:int , layer:Layer ):Tile
		{
			if(_map.tilesDic && _map.tilesDic[ layer.data[rowIndex][colIndex]-1])
			{
				return _map.tilesDic[ layer.data[rowIndex][colIndex]-1 ] as Tile;
			}
			return null;
		}
		
		public function getLayerBitmap( layer:Layer , transparent:Boolean=true , fillColor:uint = 0xffffff  ):Bitmap
		{
			var bmd:BitmapData = new BitmapData(layer.width*_map.tileheight , layer.height*_map.tilewidth , transparent , fillColor );
			var tileBmd:BitmapData ;
			for( var i:int = 0 ; i< layer.height ; i++)
			{
				for( var j:int = 0 ; j<layer.width ; j++)
				{
					if(layer.data[i][j]>0)
					{
						tileBmd = getTileBmd(layer.data[i][j]) ;
						if(tileBmd)
						{
							bmd.copyPixels( tileBmd,tileBmd.rect,new Point ( j*_map.tilewidth  , i*_map.tileheight ), null,null,true);
						}
					}
				}
			}
			return new Bitmap(bmd) ;
		}
		
		private function getTileBmd( num:int ):BitmapData
		{
			var tileset:Tileset ;
			for( var i:int = _map.tilesets.length-1 ; i>=0 ;  i--)
			{
				tileset = _map.tilesets[i];
				if(tileset.firstgrid<=num)
				{
					return tileset.bmds[num-tileset.firstgrid] ;
				}
			}
			return null ;
		}
		
		//=====================================dipose
		
		public function disposeMap():void 
		{
			_config = null ;
			_urlLoader = null ;
			_map = null ;
			if(_resLoader) _resLoader.dispose();
			_resLoader = null ;
		}
		
		//=============静态方法====================
		/**
		 * 获得行索引 
		 * @param cellHeight
		 * @param py
		 * @return 
		 * 
		 */		
		public static function getRowIndex( cellHeight:int , py:int ):int
		{
			return Math.floor( py/cellHeight);
		}
		/**
		 * 获得列索引 
		 * @param cellWidth
		 * @param px
		 * @return 
		 * 
		 */		
		public static function getColIndex( cellWidth:int , px:int ):int
		{
			return Math.floor( px/cellWidth);
		}
	}
}