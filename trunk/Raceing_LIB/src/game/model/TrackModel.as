package game.model
{
	import bing.res.ResVO;
	
	import game.vos.AIVO;
	import game.vos.TrackVO;

	public class TrackModel
	{
		private static var _instance:TrackModel;
		public static function get instance():TrackModel{
			if(!_instance) _instance = new TrackModel();
			return _instance ;
		}
		//===============================
		
		/**
		 * 解锁的赛道 id 
		 */		
		public var unlockTracks:Vector.<int> = new Vector.<int>();
		
		/**
		 * 所有的赛道 
		 */		
		public var tracks:Vector.<TrackVO> = new Vector.<TrackVO>();
		
		/**
		 * 解析所有的赛道数据 
		 * @param resVO
		 */		
		public function parseConfig( resVO:ResVO ):void
		{
			var config:XML = XML(resVO.resObject);
			for each( var item:* in config.children())
			{
				var vo:TrackVO = new TrackVO();
				tracks.push( vo );
				vo.id = int( item.id );
				vo.name = String( item.name );
				vo.costCoin = int( item.costCoin ); //解锁用
				vo.costCash = int( item.costCash );
				vo.requireLevel = int( item.requireLevel );
				vo.info = String( item.info );
				vo.elasticity=Number(item.elasticity);
				vo.dynamicFriction=Number(item.dynamicFriction);
				vo.staticFriction=Number(item.staticFriction);
				vo.density=Number(item.density);
				vo.rollingFriction=Number(item.rollingFriction);
				vo.gravity = int(item.gravity);
				vo.bgColors = String(item.bgColors).split(",") ;
				
				vo.competitors = new Vector.<AIVO>();
				for each( var competitor:* in item.competitors.children() )
				{
					var ai:AIVO = new AIVO();
					vo.competitors.push(ai);
					ai.carId = int(competitor.@carId);
					ai.name = String(competitor.@name);
					ai.head = String(competitor.@head);
					ai.earnCoin = int(competitor.@earnCoin);
					ai.earnExp = int(competitor.@earnExp);
					ai.density = Number(competitor.@density);
					ai.frequency = Number(competitor.@frequency);
					ai.impulse = Number(competitor.@impulse);
					ai.velocity = Number(competitor.@velocity);
					ai.mass = Number(competitor.@mass);
					ai.drive = int(competitor.@drive);
				}
			}
		}
	}
}