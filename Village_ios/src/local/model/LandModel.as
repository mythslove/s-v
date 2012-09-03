package local.model
{
	import local.vo.LandVO;

	/**
	 * 土地可用区域 
	 * @author zhouzhanglin
	 */	
	public class LandModel
	{
		private static var _instance:LandModel ;
		public static function get instance():LandModel
		{
			if(!_instance) _instance = new LandModel();
			return _instance;
		}
		//=======================================
		
		public var lands:Vector.<LandVO> ;
		
		//如果当前没有Land，则初始化四块地
		public function initLands():void
		{
			lands = new Vector.<LandVO>(6,true);
			var vo:LandVO ;
			var count:int ;
			for( var i:int = 0 ; i <3 ; ++i ){
				for( var j:uint = 0 ; j<2 ; ++j ){
					vo= new LandVO();
					vo.nodeX = 6+i ;
					vo.nodeZ = 6+j ;
					lands[count] = vo ;
					++count ;
				}
			}
		}
	}
}