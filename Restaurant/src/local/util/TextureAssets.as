package local.util
{
	import bing.ds.HashMap;
	import bing.res.ResVO;
	import bing.starling.component.PixelsImage;
	import bing.starling.component.PixelsMovieClip;
	import bing.utils.MaxRectsBinPack;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import local.enum.ItemType;
	import local.model.ShopModel;
	import local.vo.BaseItemVO;
	import local.vo.BitmapAnimResVO;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class TextureAssets
	{
		private static var _instance:TextureAssets ;
		public static function get instance():TextureAssets{
			if(!_instance) _instance = new TextureAssets();
			return _instance ;
		}
		//=======================================
		
		[Embed(source="assets/wall/WALL_LEFT.bd", mimeType="application/octet-stream") ]
		private const WALL_LEFT:Class ;
		[Embed(source="assets/wall/WALL_RIGHT.bd", mimeType="application/octet-stream") ]
		private const WALL_RIGHT:Class ;
		
		
		//建筑层，主要是房间内
		public var buildingLayerTexture:TextureAtlas ;
		public var buildingLayerBmd:BitmapData ;
		
		//地面层，主要包括地板，墙，壁纸，墙上的装饰
		public var groundLayerTexture:TextureAtlas ;
		public var groundLayerBmd:BitmapData ;
		
		
		/**
		 * key为资源名字，value为BitmapAnimResVO
		 */		
		private var _resNameHash:Dictionary = new Dictionary();
		
		/**
		 * 动态创建材质 
		 */		
		public function createBuildingTexture():void
		{
			var buildingName2Rect:HashMap = new HashMap();
			var groundName2Rect:HashMap = new HashMap();
			buildingLayerBmd = new BitmapData(1024,1024,true,0xffffff) ;
			groundLayerBmd = new BitmapData(1024,1024,true,0xffffff);
			var buildingMaxRect:MaxRectsBinPack = new MaxRectsBinPack(1024,1024,false);
			var groundMaxRect:MaxRectsBinPack = new MaxRectsBinPack(1024,1024,false);
			
			var allItemsHash:Dictionary = ShopModel.instance.allItemsHash ;
			if( allItemsHash)
			{
				//拼接图片
				var baseVO:BaseItemVO ;
				for ( var name:String in allItemsHash){
					baseVO =  allItemsHash[name] as BaseItemVO ;
					if(baseVO.directions==4){
						check( baseVO , name+"_1");
						check( baseVO , name+"_2");
					}else{
						check( baseVO , name);
					}
				}
				
				function check( baseVO:BaseItemVO , name:String ):void
				{
					var resVO:ResVO = ResourceUtil.instance.getResVOByResId(name);
					if(resVO){
						if(baseVO.type==ItemType.FLOOR || baseVO.type==ItemType.WALL_DECOR || baseVO.type==ItemType.WALL_PAPER){
							parseBarvos( name , groundLayerBmd , groundName2Rect , resVO.resObject as Vector.<BitmapAnimResVO> , groundMaxRect );
						}else{
							parseBarvos( name , buildingLayerBmd , buildingName2Rect , resVO.resObject as Vector.<BitmapAnimResVO> , buildingMaxRect );
						}
					}
				}
				
				//绑定的材质
				var resVO:ResVO = new ResVO("WALL_LEFT")  ;
				ResourceUtil.instance.parseAnimFile( resVO, new WALL_LEFT() as ByteArray) ;
				parseBarvos( resVO.resId , groundLayerBmd , groundName2Rect , resVO.resObject as Vector.<BitmapAnimResVO> , groundMaxRect );
				resVO = new ResVO("WALL_RIGHT")  ;
				ResourceUtil.instance.parseAnimFile( resVO, new WALL_RIGHT() as ByteArray) ;
				parseBarvos( resVO.resId , groundLayerBmd , groundName2Rect , resVO.resObject as Vector.<BitmapAnimResVO> , groundMaxRect );
				
				
				//创建材质
				var buildingTexture:Texture = Texture.fromBitmapData( buildingLayerBmd , false ) ;
				buildingLayerTexture = new TextureAtlas(buildingTexture);
				var len:int = buildingName2Rect.keys().length ;
				for ( var i:int = 0 ; i<len ; ++i){
					name = buildingName2Rect.keys()[i] ;
					buildingLayerTexture.addRegion( name , buildingName2Rect.getValue(name) as Rectangle);
				}
				
				var groundTexture:Texture = Texture.fromBitmapData( groundLayerBmd , false ) ;
				groundLayerTexture = new TextureAtlas(groundTexture);
				len = groundName2Rect.keys().length ;
				for ( i = 0 ; i<len ; ++i){
					name = groundName2Rect.keys()[i] ;
					groundLayerTexture.addRegion( name , groundName2Rect.getValue(name) as Rectangle);
				}
				
				//释放资源
				buildingName2Rect.clear();
				buildingName2Rect = null ;
				groundName2Rect.clear();
				groundName2Rect = null ;
				buildingTexture = null ;
				groundTexture = null ;
				_resNameHash = null ;
				ResourceUtil.instance.resNameHash = null ;
				System.gc() ;
			}
			
		}
		
		private function parseBarvos( name:String , layerBmd:BitmapData , name2Rect:HashMap , barvos:Vector.<BitmapAnimResVO> , maxRect:MaxRectsBinPack ):void
		{
			var rect:Rectangle ;
			var bmd:BitmapData ;
			var layer:int ; //层数
			var ext:String ;
			var mat:Matrix = new Matrix();
			for each( var vo:BitmapAnimResVO in barvos){
				if(vo.bmds){
					if(!_resNameHash.hasOwnProperty(vo.resName)){
						for( var i:int = 0 ; i<vo.bmds.length ; ++i){
							mat.identity() ;
							bmd = vo.bmds[i] ;
							rect  = maxRect.insert( bmd.width , bmd.height , MaxRectsBinPack.ContactPointRule) ;
							mat.translate( rect.x , rect.y );
							layerBmd.draw( bmd , mat );
							ext = i<10?"00"+i :  ( i<100?"0"+i:i+"") ;
							name2Rect.put( vo.resName+"_"+ext , rect ) ;
							bmd.dispose() ;
						}
						_resNameHash[vo.resName] = vo ;
					}else{
						trace("相同材质:"+vo.resName);
					}
				}
				++layer ;
				vo.bmds = null ;
			}
		}
		
		/**
		 * 建筑层 
		 * @param name
		 * @return 
		 * 
		 */		
		public function createBDLayerPixelsImage( name:String ):PixelsImage
		{
			return new PixelsImage(buildingLayerTexture.getTexture(name) , buildingLayerBmd , buildingLayerTexture.getRegion(name)  ); 
		}
		
		/**
		 * 建筑层动画 
		 * @param name
		 * @param regions
		 * @param fps
		 * @return 
		 */		
		public function createBDLayerPixelsMovieClip( name:String ,regions:Vector.<Rectangle>, fps:Number ):PixelsMovieClip
		{
			return new PixelsMovieClip(buildingLayerTexture.getTextures(name),  buildingLayerBmd , regions ,fps );
		}
		
		/**
		 * 地面层 
		 * @param name
		 * @return 
		 */		
		public function createGDLayerPixelsImage( name:String ):PixelsImage
		{
			return new PixelsImage(groundLayerTexture.getTexture(name) , groundLayerBmd , groundLayerTexture.getRegion(name)  ); 
		}
	}
}