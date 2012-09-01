package local.util
{
	import bing.res.ResVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
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
		
		[ Embed(source="../resource/character/Fairy.bd", mimeType="application/octet-stream") ]
		public static const Fairy:Class ;
		[ Embed(source="../resource/character/Truck.bd", mimeType="application/octet-stream") ]
		public static const Truck:Class ;
		
		
		[ Embed(source="../resource/bg.jpg") ]
		public static const MapBg:Class ;
		
		
		
		
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
		
		
		
		
		public function getBitmapDataByName( name :String ):BitmapData
		{
			if(_resHash[name]) {
				return _resHash[name] as BitmapData ;
			}
			var resVO:ResVO = new ResVO( name );
			resVO.resObject = (new EmbedsManager[name]() as Bitmap).bitmapData ;
			_resHash[name] = resVO.resObject ;
			return _resHash[name]  ;
		}
			
		
		
		
		
		
		
		
		
		/** 获得路区域的资源文件 */
		public function getLandRes():RoadResVO
		{
			return null ;
		}
	}
}