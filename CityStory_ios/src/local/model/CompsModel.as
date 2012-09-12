package local.model
{
	import flash.utils.Dictionary;
	
	import local.vo.ComponentVO;

	public class CompsModel
	{
		private static var _instance:CompsModel;
		public static function get instance():CompsModel
		{
			if(!_instance) _instance = new CompsModel();
			return _instance; 
		}
		//=================================
		
		public var allCompsHash:Dictionary ;
		
		
		/** 我拥有的components , key 为name , value为数量*/
		public var myComps:Dictionary ;
	}
}