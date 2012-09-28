package local.util
{
	import bing.ds.HashMap;
	import bing.res.ResVO;
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
		
		public var buildingTexture:TextureAtlas ;
		public var buildingBmd:BitmapData = new BitmapData(2048,2048,true,0xffffff);
		
		
		public function createBuildingTexture():void
		{
			var name2Rect:HashMap = new HashMap();
			var maxRect:MaxRectsBinPack = new MaxRectsBinPack(2048,2048,false);
			var allBuildingHash:Dictionary = ShopModel.instance.allBuildingHash ;
			if( allBuildingHash){
				
				//拼接图片
				var baseVO:BaseBuildingVO ;
				var resVO:ResVO ;
				for ( var name:String in allBuildingHash){
					baseVO =  allBuildingHash[name] as BaseBuildingVO ;
					resVO = ResourceUtil.instance.getResVOByResId(name);
					if(baseVO.subClass==BuildingType.DECORATION_ROAD || baseVO.subClass==BuildingType.DECORATION_GROUND){
						parseResRoad( name , name2Rect , resVO.resObject as RoadResVO , maxRect );
					}else{
						parseBarvos( name , name2Rect , resVO.resObject as Vector.<BitmapAnimResVO> , maxRect );
					}
				}
				
				//创建材质
				var texture:Texture = Texture.fromBitmapData( buildingBmd , false ) ;
				buildingTexture = new TextureAtlas(texture);
				var len:int = name2Rect.keys().length ;
				for ( var i:int = 0 ; i<len ; ++i){
					name = name2Rect.keys()[i] ;
					buildingTexture.addRegion( name , name2Rect.getValue(name) as Rectangle);
				}
				name2Rect.clear();
				name2Rect = null ;
			}
			
		}
		
		private function parseBarvos( name:String , name2Rect:HashMap , barvos:Vector.<BitmapAnimResVO> , maxRect:MaxRectsBinPack ):void
		{
			var rect:Rectangle ;
			var bmd:BitmapData ;
			var layer:int ; //层数
			for each( var vo:BitmapAnimResVO in barvos){
				for( var i:int = 0 ; i<vo.bmds.length ; ++i){
					bmd = vo.bmds[i] ;
					rect  = maxRect.insert( bmd.width , bmd.height , MaxRectsBinPack.ContactPointRule) ;
					GameData.commPoint.x = rect.x ;
					GameData.commPoint.y = rect.y ;
					buildingBmd.copyPixels( bmd , bmd.rect , GameData.commPoint );
					name2Rect.put( name+"_"+layer+"_"+i , rect ) ;
					bmd.dispose() ;
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
				buildingBmd.copyPixels( bmd , bmd.rect , GameData.commPoint );
				name2Rect.put(  name+key , rect ) ;
				++i ;
				
				bmd.dispose();
			}
			roadResVO.bmds = null ;
		}
	}
}