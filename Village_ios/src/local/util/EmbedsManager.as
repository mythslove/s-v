package local.util
{
	import bing.res.ResVO;
	
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
		
		private var _bitmapAnimResVOHash:Dictionary = new Dictionary();
		
		[ Embed(source="../resource/character/Fairy.bd", mimeType="application/octet-stream") ]
		public static const Fairy:Class ;
		
		
		public function getAnimResVOByName( name:String ):Vector.<BitmapAnimResVO>
		{
			if(_bitmapAnimResVOHash[name]) {
				return _bitmapAnimResVOHash[name] as Vector.<BitmapAnimResVO> ;
			}
			var resVO:ResVO = new ResVO( name );
			ResourceUtil.instance.parseAnimFile( resVO , new EmbedsManager[name]() as ByteArray ) ;
			_bitmapAnimResVOHash[name] = resVO.resObject ;
			return _bitmapAnimResVOHash[name]  ;
		}
		
		
		/** 获得路区域的资源文件 */
		public function getLandRes():RoadResVO
		{
			return null ;
		}
	}
}