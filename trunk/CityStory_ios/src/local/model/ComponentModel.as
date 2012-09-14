package local.model
{
	import flash.utils.Dictionary;
	
	import local.vo.ComponentVO;

	public class ComponentModel
	{
		private static var _instance:ComponentModel ;
		public static function get instance():ComponentModel
		{
			if(!_instance) _instance = new ComponentModel();
			return _instance;
		}
		//=======================================
		
		/** 所有的components */
		public var allComps:Dictionary ;
		
		/** 我拥有的components*/
		public var myComps:Vector.<ComponentVO> ;
	}
}