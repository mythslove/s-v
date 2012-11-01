package local.map
{
	import flash.geom.Point;
	
	import local.comm.GameSetting;
	import local.map.item.BaseItem;
	import local.map.item.Floor;
	import local.model.PlayerModel;
	import local.model.ShopModel;
	import local.util.ItemFactory;
	import local.view.btns.MoveItemButtons;
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
				
				var table :BaseItem = ItemFactory.createItemByBaseVO( ShopModel.instance.allItemsHash["Autumn Table"] as BaseItemVO) as BaseItem;
				table.nodeX = table.nodeZ = 2 ;
				roomScene.addIsoObject( table);
				run() ;
			}
		}
		
		/**
		 * 添加Item到移动的的层上面，主要是从商店和收藏箱中的Item
		 * @param item
		 */	
		public function addItemToTopScene( item:BaseItem ):void
		{
			//放在当前屏幕中间
			var offsetY:Number = (item.itemVO.baseVO.xSpan+item.itemVO.baseVO.zSpan)*0.5*_size;
			var p:Point = pixelPointToGrid( GameSetting.SCREEN_WIDTH*0.5 , GameSetting.SCREEN_HEIGHT*0.5 , 0,  offsetY );
			item.nodeX = p.x ;
			item.nodeZ = p.y ;
			
			topScene.clearAndDisposeChild();
			topScene.addIsoObject( item , false );
			item.drawBottomGrid();
			item.bottom.updateItemGridLayer();
			
			var moveBtns:MoveItemButtons  = MoveItemButtons.instance ;
			item.addChild( moveBtns );
			if(item.bottom.getWalkable()){
				if( !moveBtns.okBtn.enabled){
					moveBtns.okBtn.enabled = true  ;
				}
			}else{
				if( moveBtns.okBtn.enabled){
					moveBtns.okBtn.enabled = false ;
				}
			}
		}
		
		
		
		
		public function expandLand():void
		{
			GameSetting.MAP_HEIGHT -= (GameSetting.MAX_SIZE-PlayerModel.instance.me.mapSize)*GameSetting.GRID_SIZE ;
		}
	}
}