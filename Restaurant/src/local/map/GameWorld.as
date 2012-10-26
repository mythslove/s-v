package local.map
{
	import local.comm.GameSetting;
	import local.map.item.Floor;
	import local.model.PlayerModel;
	import local.model.ShopModel;
	import local.util.ItemFactory;
	import local.vo.BaseItemVO;
	import local.vo.PlayerVO;
	
	import starling.animation.Juggler;
	import starling.events.EnterFrameEvent;

	public class GameWorld extends BaseWorld
	{
		private static var _instance:GameWorld;
		public static function get instance():GameWorld {
			if(!_instance) _instance = new GameWorld();
			return _instance ;
		}
		//-----------------------------------------------------------------
		private var _juggle:Juggler = new Juggler() ;
		
		public function GameWorld()
		{
			super();
			addEventListener(EnterFrameEvent.ENTER_FRAME , onEnterFrame );
		}
		
		public function run():void{ 
			_juggle.add(this);
			touchable=true ;
		}
		public function stopRun():void{ 
			_juggle.remove(this);
			touchable=false ;
		}
		
		private function onEnterFrame( e:EnterFrameEvent ):void
		{
			if(runUpdate)	{
				roomScene.advanceTime(e.passedTime) ;
			}
			if(x!=_endX) x += ( _endX-x)*_moveSpeed ; //缓动地图
			if(y!=_endY) y += (_endY-y)*_moveSpeed ;
		}
		
		
		
		
		
		/** 
		 * 显示所有的房间物品对象 
		 */
		public function showItems( isHome:Boolean=true ):void
		{
			if( isHome ) //显示自己的村庄
			{
				var player:PlayerVO = PlayerModel.instance.me ;
				
				for( var i:int = 0 ; i<player.mapSize ; ++i)
				{
					for( var j:int = 0 ; j<player.mapSize ; ++j)
					{
						var floor:Floor = ItemFactory.createItemByBaseVO( ShopModel.instance.allItemsHash["Chef Floor"] as BaseItemVO) as Floor;
						floor.nodeX = i ;
						floor.nodeZ = j ;
						floorScene.addIsoObject( floor , false );
					}
				}
				floorScene.sortAll() ;
				
				
				
				run() ;
			}
		}
		
		
		
		
		
		
		
		public function expandLand():void
		{
			this.panTo(GameSetting.MAP_WIDTH*0.5,337-(GameSetting.MAX_SIZE-GameSetting.DEFAULT_SIZE) *GameSetting.GRID_SIZE*0.5 );
		}
	}
}