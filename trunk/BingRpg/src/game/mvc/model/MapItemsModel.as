package game.mvc.model
{
	import bing.utils.ObjectUtil;
	
	import game.elements.cell.BaseItem;
	import game.elements.items.AnimationItem;
	import game.elements.items.FightNpc;
	import game.elements.items.Npc;
	import game.elements.items.Player;
	import game.events.ItemEvent;
	import game.global.GameData;
	import game.mvc.base.GameModel;
	import game.mvc.model.vo.NpcVO;

	/**
	 * 存储ItemVO
	 * 地面上的所有东西，人，npc,建筑，怪
	 * @author zhouzhanglin
	 */	
	public class MapItemsModel extends GameModel
	{
		private static var _instance:MapItemsModel;
		public static function get instance():MapItemsModel
		{
			if(!_instance) _instance = new MapItemsModel();
			return _instance ;
		}
		//====================================
		
		/** 当前鼠标在哪个对象上面 */
		public var mouseOverItem:AnimationItem ;
		//所有的对象
		private var _allItems:Vector.<AnimationItem> = new Vector.<AnimationItem>();
		
		/**
		 * 解析一张地图的配置信息,获取地图上的npc等 
		 * @param mapConfig
		 */		
		public function parseMapConfig( mapConfig:XML ):void
		{
			var npcVOXML:* = mapConfig.npc[0].npcVO ;
			const LEN:int = npcVOXML.length();
			var npcVO:NpcVO ;
			var npc:Npc ;
			for( var i:int =0 ; i<LEN ; i++)
			{
				npcVO = ObjectUtil.copyObj( ItemVOModel.instance.getNpcVOByFaceId(  int ( npcVOXML[i].@faceId) ) ) as NpcVO; 
				npcVO.name = String (npcVOXML[i].@name );
				npcVO.px = Number ( npcVOXML[i].@px );
				npcVO.py = Number ( npcVOXML[i].@py);
				npcVO.endTx = Number ( npcVOXML[i].@endTx );
				npcVO.endTy = Number ( npcVOXML[i].@endTy);
				npcVO.speed = Number ( npcVOXML[i].@speed);
				npcVO.direction = int ( npcVOXML[i].@direction);
				npcVO.mouseEnable = String(npcVOXML[i].@mouseEnable)=="true"?true:false;
				//创建NPC
				if(npcVO.simpleAttackAniName){
					npc = new FightNpc( npcVO);
				}else{
					npc = new Npc( npcVO );
				}
				this.addItem( npc );
			}
			
		}
		
		/**
		 * 不断更新场景上的对象 
		 */		
		public function updateAll():void
		{
			_allItems = _allItems.sort(compareItems);
			var index:int=0;
			var flag:Boolean=false ;
			var temp:AnimationItem ;
			for each( var item:AnimationItem in _allItems )
			{
				item.parent.setChildIndex( item , index );
				index++;
				item.onEnterFrame() ;
				if(item.mouseEnabled && item.checkHitPoint(contextView.mouseX+GameData.screenRect.x,contextView.mouseY+GameData.screenRect.y))
				{
					temp = item ;
					flag = true ;
				}
			}
			if(flag) {
				if(mouseOverItem){
					mouseOverItem.onMouseOut();
				}
				temp.onMouseOver();
				mouseOverItem = temp ;
			}else{
				if(mouseOverItem){
					mouseOverItem.onMouseOut();
				}
				mouseOverItem=null ;
			}
		}
		
		/**
		 * 排序 
		 */		
		private function compareItems( item1:BaseItem , item2:BaseItem ):int
		{
			if( item1.y>item2.y){
				return 1;
			}
			else if(item1.y==item2.y && item1.x>item2.x)
			{
				return 1;
			}
			return -1;
		}
		
		/**
		 *  添加对象到场景上和数组中
		 * @param baseItem
		 */		
		public function addItem( baseItem:BaseItem ):void
		{
			_allItems.push( baseItem );
			//抛出添加Item事件
			var itemEvt:ItemEvent = new ItemEvent( ItemEvent.ADD_ITEM );
			itemEvt.item = baseItem ;
			this.dispatchContextEvent( itemEvt );
		}
		
		/**
		 * 从数组中删除一个角色，没有dispose 
		 * @param baseItem
		 */		
		public function removeItem( baseItem:BaseItem ):void 
		{
			for( var i:int = 0 ; i<_allItems.length ; i++)
			{
				if( _allItems[i]==baseItem){
					_allItems.splice(i,1);
					
					//抛出移除Item事件
					var itemEvt:ItemEvent = new ItemEvent( ItemEvent.REMOVE_ITEM );
					itemEvt.item = baseItem ;
					this.dispatchContextEvent( itemEvt );
					return ;
				}
			}
		}
		
		/**
		 * 通过id删除一个玩家  
		 * @param id
		 */		
		public function removePlayerById( id:int ):void 
		{
			for( var i:int = 0 ; i<_allItems.length ; i++)
			{
				if( (_allItems[i] is Player) &&  (_allItems[i] as Player).id==id)
				{
					_allItems.splice(i,1);
					//抛出移除Item事件
					var itemEvt:ItemEvent = new ItemEvent( ItemEvent.REMOVE_ITEM );
					itemEvt.item = _allItems[i] ;
					this.dispatchContextEvent( itemEvt );
					return ;
				}
			}
		}
		
		/**
		 * 清理地图上的数据 
		 */		
		public function clearMapItemsData():void 
		{
			for each( var item:BaseItem in _allItems)
			{
				item.dispose();
			}
			_allItems = new Vector.<BaseItem>();
			mouseOverItem = null ;
		}
		
		/**
		 * 通过id来获取角色 
		 * @param id
		 * @return 
		 */		
		public function getPlayerById( id:int ):Player
		{
			for each( var item:BaseItem in _allItems)
			{
				if( ( item is Player) && (item as Player).id==id ){
					return item as Player ;
				}
			}
			return null ;
		}
	}
}