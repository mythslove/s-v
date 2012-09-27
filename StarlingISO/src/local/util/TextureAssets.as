package local.util
{
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
			var name2Rect:Dictionary = new Dictionary();
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
				var count:int ;
				for ( name in allBuildingHash){
					baseVO =  allBuildingHash[name] as BaseBuildingVO ;
					resVO = ResourceUtil.instance.getResVOByResId(name);
					if(baseVO.subClass==BuildingType.DECORATION_ROAD || baseVO.subClass==BuildingType.DECORATION_GROUND){
						var roadResVO:RoadResVO  = resVO.resObject as RoadResVO;
						var i:int ;
						for( var key:String in roadResVO.bmds){
							buildingTexture.addRegion( baseVO.name+key,maxRect.usedRectangles[count]);
							(roadResVO.bmds[key] as BitmapData).dispose() ;
							++i ;
							++count ;
						}
						roadResVO.bmds = null ;
					}else{
						var barvos:Vector.<BitmapAnimResVO> = resVO.resObject as Vector.<BitmapAnimResVO> ;
						for( i = 0 ; i<barvos.length ; ++i){
							for( var j:int = 0 ; j<barvos[i].bmds.length ; ++j ){
								buildingTexture.addRegion( baseVO.name+"_"+i+"_"+j , maxRect.usedRectangles[count]);
								barvos[i].bmds[j].dispose();
								++count;
							}
							barvos[i].bmds = null ;
						}
					}
				}
			}
			
		}
		
		private function parseBarvos( name:String , name2Rect:Dictionary , barvos:Vector.<BitmapAnimResVO> , maxRect:MaxRectsBinPack ):void
		{
			var rect:Rectangle ;
			var bmd:BitmapData ;
			var layer:int ; //层数
			for each( var vo:BitmapAnimResVO in barvos){
				for( var i:int = 0 ; i<vo.bmds.length ; ++i){
					bmd = vo.bmds[i] ;
					rect  = maxRect.insert( bmd.width , bmd.height , MaxRectsBinPack.ContactPointRule) ;
					buildingBmd.copyPixels( bmd , bmd.rect , GameData.commPoint );
					name2Rect[name+"_"+layer+"_"+i ] = rect ;
					++layer ;
					
					bmd.dispose() ;
				}
				vo.bmds = null ;
			}
		}
		
		private function parseResRoad(  name:String , name2Rect:Dictionary , roadResVO:RoadResVO , maxRect:MaxRectsBinPack ):void
		{
			var rect:Rectangle ;
			var bmd:BitmapData ;
			var i:int ;
			for( var key:String in roadResVO.bmds){
				bmd = roadResVO.bmds[key] as BitmapData ;
				rect  = maxRect.insert( bmd.width , bmd.height , MaxRectsBinPack.ContactPointRule) ;
				buildingBmd.copyPixels( bmd , bmd.rect , GameData.commPoint );
				name2Rect[name+key ] = rect ;
				++i ;
				
				bmd.dispose();
			}
			roadResVO.bmds = null ;
		}
	}
}