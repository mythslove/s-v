package local.util
{
	import bing.res.ResVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import local.comm.GameSetting;
	import local.view.pk.*;
	import local.vo.BitmapAnimResVO;
	import local.vo.RoadResVO;
	
	import pxBitmapFont.PxBitmapFont;

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
		
		[Embed(source="../resource/font/GROBOLD.ttf",fontName="grobold",embedAsCFF="false")]
		public static const GROBOLD:Class ;
		
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
		[Embed(source="../resource/comm/ProductsExpiredFlag.png")]
		public static const ProductsExpiredFlag:Class; //产品过期标志
		
		
		
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
		
		
		
		//===================特效===========================
		[Embed(source="../resource/effect/PlaceBuildingEffect.bd", mimeType="application/octet-stream") ]
		public static const PlaceBuildingEffect:Class;  //放置建筑时的灰尘特效
		[Embed(source="../resource/effect/ExpandSign.bd", mimeType="application/octet-stream") ]
		public static const ExpandSign:Class ; //扩地标识
		[Embed(source="../resource/effect/ExpandBuilding.bd", mimeType="application/octet-stream") ]
		public static const ExpandBuilding:Class ; //扩地后上面的占位建筑
		
		
		
		//================BitmapFont字体===========================
		[Embed(source="../resource/font/Verdana.fnt", mimeType="application/octet-stream") ]
		public static const VerdanaBigFnt:Class;
		[Embed(source="../resource/font/Verdana.png") ]
		public static const VerdanaBig:Class;
		[Embed(source="../resource/font/VerdanaSmall_iphone.fnt", mimeType="application/octet-stream") ]
		public static const VerdanaSmallFnt_iphone:Class;
		[Embed(source="../resource/font/VerdanaSmall_iphone.png") ]
		public static const VerdanaSmall_iphone:Class;
		
		
		
		
		
		//==================swf中的图片资源==============================
		public static const CashBMD:BitmapData = new Cash(0,0);
		public static const CoinBMD:BitmapData = new Coin(0,0);
		public static const EnergyBMD:BitmapData = new Energy(0,0);
		public static const ExpBMD:BitmapData = new Exp(0,0);
		public static const GoodsBMD:BitmapData = new Goods(0,0);
		public static const StoneBMD:BitmapData = new Stone(0,0);
		public static const WoodBMD:BitmapData = new Wood(0,0);
		
		/**
		 * 返回pickup bitmapData 
		 * @param name
		 * @return 
		 */		
		public function getPKBmd( name:String ):BitmapData{
			return EmbedsManager[name+"BMD"] ;
		}
		
		
		
		/**
		 * 返回BitmapFont配置 
		 * @param name
		 * @return 
		 */		
		public function getBitmapFontByName(name:String , device:Boolean=true):PxBitmapFont
		{
			var ext:String = "";
			if(device) ext = "_"+GameSetting.device ;
			if(_resHash[name]) {
				return _resHash[name] as PxBitmapFont;
			}
			var bmd:BitmapData = ( new EmbedsManager[name+ext]() as Bitmap).bitmapData ;
			var config:XML = XML( new EmbedsManager[name+"Fnt"+ext]() )  ;
			_resHash[name] = new PxBitmapFont().loadAngelCode( bmd , config );
			
			return _resHash[name] as PxBitmapFont ;
		}
		
		
		/**
		 * 获得嵌入的动画文件  
		 * @param name
		 * @return 
		 */		
		public function getAnimResVOByName( name:String , device:Boolean=false ):Vector.<BitmapAnimResVO>
		{
			if(device) name+="_"+GameSetting.device ;
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
		public function getBitmapByName( name :String , device:Boolean = false ):Bitmap
		{
			if(device) name+="_"+GameSetting.device ;
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
		public function getRoadResVOByName( name:String  , device:Boolean = false ):RoadResVO
		{
			if(device) name+="_"+GameSetting.device ;
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