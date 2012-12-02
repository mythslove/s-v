package game.model
{
	import bing.res.ResVO;
	
	import game.vos.TrackVO;

	public class TrackModel
	{
		private static var _instance:TrackModel;
		public static function get instance():TrackModel{
			if(!_instance) _instance = new TrackModel();
			return _instance ;
		}
		//===============================
		public var tracks:Vector.<TrackVO> ;
		
		public function parseConfig( resVO:ResVO ):void
		{
			tracks = new Vector.<TrackVO>();
			var config:XML = XML(resVO.resObject);
			for each( var item:* in config.children())
			{
				var vo:TrackVO = new TrackVO();
				tracks.push( vo );
				vo.id = int( item.id );
				vo.name = String( item.name );
				vo.costCoin = int( item.costCoin );
				vo.costCash = int( item.costCash );
				vo.requireLevel = int( item.requireLevel );
				vo.info = String( item.info );
				vo.elasticity = Number( item.elasticity );
				vo.dynamicFriction = Number( item.dynamicFriction );
				vo.staticFriction = Number( item.staticFriction );
				vo.density = Number( item.density );
				vo.rollingFriction = Number( item.rollingFriction );
			}
		}
	}
}