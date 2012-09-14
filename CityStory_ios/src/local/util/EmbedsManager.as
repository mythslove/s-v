package local.util
{
	import bing.res.ResVO;
	
	import flash.display.Bitmap;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import local.vo.BitmapAnimResVO;
	import local.vo.RoadResVO;

	/**
	 * 绑定的资源 管理类
	 * @author zhouzhanglin
	 */	
	public class EmbedsManager
	{
		private static var _instance:EmbedsManager; 
		public static function get instance():EmbedsManager
		{
			if(!_instance) _instance = new EmbedsManager();
			return _instance ;
		}
		//==================================
		
		private var _resHash:Dictionary = new Dictionary();
		
		
		//================地图上行走的人和车=================================
		[ Embed(source="../resource/character/Fairy.bd", mimeType="application/octet-stream") ]
		public static const Fairy:Class ;
		[ Embed(source="../resource/character/Red Car.bd", mimeType="application/octet-stream") ]
		public static const RedCar:Class ;
		[ Embed(source="../resource/character/Yellow Car.bd", mimeType="application/octet-stream") ]
		public static const YellowCar:Class ;
		//=======================================
		
		
		//=========地图资源，地图数据和图片======================
		[ Embed(source="../resource/map/mapData.map", mimeType="application/octet-stream") ]
		public static const MapData:Class ; //地图数据
		[ Embed(source="../resource/map/bottomsea1.png") ]
		public static const Bottomsea1:Class ;
		[ Embed(source="../resource/map/bottomsea2.png") ]
		public static const Bottomsea2:Class ;
		[ Embed(source="../resource/map/rightsea1.png") ]
		public static const Rightsea1:Class ;
		[ Embed(source="../resource/map/rightsea2.png") ]
		public static const Rightsea2:Class ;
		[ Embed(source="../resource/map/heightmap1.png") ]
		public static const HeightMap1:Class ;
		[ Embed(source="../resource/map/heightmap2.png") ]
		public static const HeightMap2:Class ;
		[ Embed(source="../resource/map/rightheight1.png") ]
		public static const RightHeight1:Class ;
		[ Embed(source="../resource/map/smallheightmap1.png") ]
		public static const SmallHeightMap:Class ;
		[ Embed(source="../resource/map/water1.png") ]
		public static const Water1:Class ;
		[ Embed(source="../resource/map/mapBlock.png") ]
		public static const MapBlock:Class ;
		//=======================================
		
		
		[Embed(source="../resource/comm/BuildingBottomGridRed.png")]
		public static const BuildingBottomGridRed:Class; //建筑的底座
		[Embed(source="../resource/comm/BuildingBottomGridGreen.png")]
		public static const BuildingBottomGridGreen:Class;//建筑的底座
		
		
		[Embed(source="../resource/comm/ExpandLandButton.png")]
		public static const ExpandLandButton:Class;//扩地的图标
		
		
		[Embed(source="../resource/comm/CollectCoinFlag.png")]
		public static const CollectCoinFlag:Class; //收藏金币时的标志
		[Embed(source="../resource/comm/CollectGoodsFlag.png")]
		public static const CollectGoodsFlag:Class; //收获商品时的标志
		[Embed(source="../resource/comm/AddGoodsFlag.png")]
		public static const AddGoodsFlag:Class; //需要商品时的标志
		[Embed(source="../resource/comm/NeedRoadsFlag.png")]
		public static const NeedRoadsFlag:Class; //建筑没在路边时的标志
		[Embed(source="../resource/comm/AddProductFlag.png")]
		public static const AddProductFlag:Class; //需要产品时的标志
		
		
		
		//========建筑修建时的状态图标====================
		[Embed(source="../resource/effect/BuildStatus_1_0.bd", mimeType="application/octet-stream") ]
		public static const BuildStatus_1_0:Class; 
		[Embed(source="../resource/effect/BuildStatus_1_1.bd", mimeType="application/octet-stream") ]
		public static const BuildStatus_1_1:Class; 
		[Embed(source="../resource/effect/BuildStatus_2_0.bd", mimeType="application/octet-stream") ]
		public static const BuildStatus_2_0:Class; 
		[Embed(source="../resource/effect/BuildStatus_2_1.bd", mimeType="application/octet-stream") ]
		public static const BuildStatus_2_1:Class; 
		[Embed(source="../resource/effect/BuildStatus_3_0.bd", mimeType="application/octet-stream") ]
		public static const BuildStatus_3_0:Class; 
		[Embed(source="../resource/effect/BuildStatus_3_1.bd", mimeType="application/octet-stream") ]
		public static const BuildStatus_3_1:Class; 
		
		
		
		
		/**
		 * 获得嵌入的动画文件  
		 * @param name
		 * @return 
		 */		
		public function getAnimResVOByName( name:String ):Vector.<BitmapAnimResVO>
		{
			if(_resHash[name]) {
				return _resHash[name] as Vector.<BitmapAnimResVO> ;
			}
			var resVO:ResVO = new ResVO( name );
			ResourceUtil.instance.parseAnimFile( resVO , new EmbedsManager[name]() as ByteArray ) ;
			_resHash[name] = resVO.resObject ;
			return _resHash[name]  ;
		}
		
		
		
		/**
		 * 获得嵌入的图片文件  
		 * @param name
		 * @return 
		 */		
		public function getBitmapByName( name :String ):Bitmap
		{
			if(_resHash[name]) {
				return _resHash[name] as Bitmap ;
			}
			var resVO:ResVO = new ResVO( name );
			resVO.resObject =new EmbedsManager[name]() as Bitmap ;
			_resHash[name] = resVO.resObject ;
			return _resHash[name]  ;
		}
			
		
		
		/**
		 * 获得嵌入的路资源文件  
		 * @param name
		 * @return 
		 */		
		public function getRoadResVOByName( name:String ):RoadResVO
		{
			if(_resHash[name]) {
				return _resHash[name] as RoadResVO ;
			}
			var resVO:ResVO = new ResVO( name );
			ResourceUtil.instance.parseRoadFile( resVO , new EmbedsManager[name]() as ByteArray ) ;
			_resHash[name] = resVO.resObject ;
			return _resHash[name]  ;
		}
	}
}