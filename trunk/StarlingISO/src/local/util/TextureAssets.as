package local.util
{
	import bing.ds.HashMap;
	import bing.res.ResVO;
	import bing.starling.component.PixelsImage;
	import bing.starling.component.PixelsMovieClip;
	import bing.utils.MaxRectsBinPack;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import local.comm.GameData;
	import local.enum.BuildingType;
	import local.model.ShopModel;
	import local.vo.BaseBuildingVO;
	import local.vo.BitmapAnimResVO;
	import local.vo.RoadResVO;
	
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
		//建筑层
		public var buildingLayerTexture:TextureAtlas ;
		public var buildingLayerBmd:BitmapData = new BitmapData(2048,2048,true,0xffffff);
		
		//地面层
		public var groundLayerTexture:TextureAtlas ;
		public var groundLayerBmd:BitmapData = new BitmapData(1024,1024,true,0xffffff);
		
		
		/**
		 * key为资源名字，value为BitmapAnimResVO
		 */		
		private var _resNameHash:Dictionary = new Dictionary();
		
		
		public function createBuildingTexture():void
		{
			var buildingName2Rect:HashMap = new HashMap();
			var buildingMaxRect:MaxRectsBinPack = new MaxRectsBinPack(2048,2048,false);
			
			var groundName2Rect:HashMap = new HashMap();
			var groundMaxRect:MaxRectsBinPack = new MaxRectsBinPack(2048,1024,false);
			
			var allBuildingHash:Dictionary = ShopModel.instance.allBuildingHash ;
			if( allBuildingHash)
			{
				//拼接图片
				var baseVO:BaseBuildingVO ;
				var resVO:ResVO ;
				for ( var name:String in allBuildingHash){
					baseVO =  allBuildingHash[name] as BaseBuildingVO ;
					resVO = ResourceUtil.instance.getResVOByResId(name);
					if(resVO){
						if(baseVO.subClass==BuildingType.DECORATION_ROAD || baseVO.subClass==BuildingType.DECORATION_GROUND){
							parseResRoad( name , groundName2Rect , resVO.resObject as RoadResVO , groundMaxRect );
						}else{
							parseBarvos( name , buildingName2Rect , resVO.resObject as Vector.<BitmapAnimResVO> , buildingMaxRect );
						}
					}
				}
				
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
			}
			
		}
		
		private function parseBarvos( name:String , name2Rect:HashMap , barvos:Vector.<BitmapAnimResVO> , maxRect:MaxRectsBinPack ):void
		{
			var rect:Rectangle ;
			var bmd:BitmapData ;
			var layer:int ; //层数
			var ext:String ;
			for each( var vo:BitmapAnimResVO in barvos){
				if(!_resNameHash.hasOwnProperty(vo.resName)){
					for( var i:int = 0 ; i<vo.bmds.length ; ++i){
						bmd = vo.bmds[i] ;
						rect  = maxRect.insert( bmd.width , bmd.height , MaxRectsBinPack.ContactPointRule) ;
						GameData.commPoint.x = rect.x ;
						GameData.commPoint.y = rect.y ;
						buildingLayerBmd.copyPixels( bmd , bmd.rect , GameData.commPoint );
						ext = i<10?"00"+i :  ( i<100?"0"+i:i+"") ;
						name2Rect.put( vo.resName+"_"+ext , rect ) ;
						bmd.dispose() ;
					}
					_resNameHash[vo.resName] = vo ;
				}else{
					trace("相同材质:"+vo.resName);
				}
				++layer ;
				vo.bmds = null ;
			}
		}
		
		private function parseResRoad(  name:String , name2Rect:HashMap , roadResVO:RoadResVO , maxRect:MaxRectsBinPack ):void
		{
			var rect:Rectangle ;
			var bmd:BitmapData ;
			var i:int ;
			for( var key:String in roadResVO.bmds){
				bmd = roadResVO.bmds[key] as BitmapData ;
				rect  = maxRect.insert( bmd.width , bmd.height , MaxRectsBinPack.ContactPointRule) ;
				GameData.commPoint.x = rect.x ;
				GameData.commPoint.y = rect.y ;
				groundLayerBmd.copyPixels( bmd , bmd.rect , GameData.commPoint );
				name2Rect.put(  key , rect ) ;
				++i ;
				
				bmd.dispose();
			}
			roadResVO.bmds = null ;
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