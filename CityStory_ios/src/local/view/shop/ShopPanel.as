package local.view.shop
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	import local.comm.GameData;
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.map.item.BaseBuilding;
	import local.model.PlayerModel;
	import local.util.BuildingFactory;
	import local.util.PopUpManager;
	import local.view.btn.PageButton;
	import local.view.control.HPageScroller;
	import local.view.tutor.TutorView;
	import local.vo.BaseBuildingVO;
	import local.vo.PlayerVO;
	
	public class ShopPanel extends Sprite
	{
		public var container:Sprite ;
		protected var _scroll:HPageScroller = new HPageScroller() ;
		protected var _content:Sprite = new Sprite() ;
		public function get content():Sprite{return _content;}
		
		public var prevPageBtn:PageButton = new PageButton() ;
		public var nextPageBtn:PageButton = new PageButton() ;
		
		public function ShopPanel()
		{
			super();
			container = new Sprite();
			container.x = 30 ;
			container.y = 75 ;
			container.graphics.beginFill(0,0);
			container.graphics.drawRect(0,0,825,370);
			container.graphics.endFill();
			addChild(container);
			container.addChild(_content);
			prevPageBtn = new PageButton();
			prevPageBtn.scaleX = -1 ;
			prevPageBtn.x = 10 ;
			prevPageBtn.y = 250 ;
			addChild(prevPageBtn);
			nextPageBtn = new PageButton();
			nextPageBtn.x = 873;
			nextPageBtn.y = 250 ;
			addChild(nextPageBtn);
			
			_content.addEventListener(MouseEvent.CLICK , onItemHandler );
			_content.addEventListener(MouseEvent.MOUSE_DOWN , mouseHandler );
			_content.addEventListener(MouseEvent.MOUSE_UP , mouseHandler );
			_content.addEventListener(MouseEvent.ROLL_OUT , mouseHandler );
			_content.addEventListener(MouseEvent.RELEASE_OUTSIDE , mouseHandler );
			_content.addEventListener(MouseEvent.MOUSE_MOVE , mouseHandler );
			_scroll.addEventListener( HPageScroller.SCROLL_POSITION_CHANGE , scrollChangeHandler );
			_scroll.addEventListener( HPageScroller.SCROLL_OVER , scrollChangeHandler );
			
			nextPageBtn.addEventListener(MouseEvent.CLICK , pageClickHandler );
			prevPageBtn.addEventListener(MouseEvent.CLICK , pageClickHandler );
		}
		
		/**
		 * 刷新翻页按钮状态 
		 */		
		public function refreshPageButton():void
		{
			prevPageBtn.visible = _scroll.hasPrevPage() ;
			nextPageBtn.visible = _scroll.hasNextPage() ;
		}
		
		private function scrollChangeHandler( e:Event ):void
		{
			if(e.type == HPageScroller.SCROLL_OVER )
			{
				prevPageBtn.visible = _scroll.hasPrevPage() ;
				nextPageBtn.visible = _scroll.hasNextPage() ;
			}
			else
			{
				if(prevPageBtn.visible || nextPageBtn.visible){
					prevPageBtn.visible = nextPageBtn.visible = false ;
				}
			}
		}
		
		private function pageClickHandler(e:MouseEvent):void
		{
			e.stopPropagation() ;
			if(e.target == nextPageBtn) _scroll.nextPage();
			else _scroll.prevPage() ;
		}
		
		protected function onItemHandler( e:MouseEvent):void
		{
			e.stopPropagation();
			if(GameData.isShowTutor){
				TutorView.instance.clearMask();
			}
		}
		
		private function mouseHandler( e:MouseEvent ):void
		{
			if(e.target is ShopItemRenderer){
				var render:ShopItemRenderer = e.target as ShopItemRenderer ;
				switch(e.type)
				{
					case MouseEvent.MOUSE_DOWN:
						var colorTf:ColorTransform = render.transform.colorTransform ;
						colorTf.redMultiplier = 0.5 ;
						colorTf.greenMultiplier = 0.5 ;
						colorTf.blueMultiplier = 0.5 ;
						render.transform.colorTransform = colorTf ;
						break ;
					default:
						colorTf = render.transform.colorTransform ;
						if( colorTf.redMultiplier != 1 ){
							colorTf.redMultiplier = 1 ;
							colorTf.greenMultiplier = 1 ;
							colorTf.blueMultiplier = 1 ;
							render.transform.colorTransform = colorTf ;
						}
						break ;
				}
			}
		}
		
		/**
		 * 将item转换成建筑，放到场景上 
		 * @param item
		 */		
		public function addItemToWorld( render:ShopItemRenderer ):void
		{
			var building:BaseBuilding = BuildingFactory.createBuildingByBaseVO( render.baseVO );
			
			GameWorld.instance.addBuildingToTopScene( building);
			GameData.villageMode=VillageMode.BUILDING_SHOP ;
			PopUpManager.instance.removeCurrentPopup();
		}
		
		/**
		 * 判断钱是否够，如果不够并且提示 
		 * @param render
		 * @return 够返回true 
		 */		
		public function checkMoney(  render:ShopItemRenderer ):Boolean
		{
			var baseVO:BaseBuildingVO = render.baseVO ;
			var me:PlayerVO = PlayerModel.instance.me ;
		
			if( me.cash>= baseVO.priceCash && me.coin>= baseVO.priceCoin){
				return true ;
			}else{
				if( me.cash < baseVO.priceCash ){
					trace("cash 不够");
				}else{
					trace("coin 不够");
				}
			}
			return false ;
		}
		
		/**
		 *  滚动位置直接滚到name建筑位置
		 * @param name
		 */		
		public function scrollToBuilding( buildName:String ):void
		{
			var item:ShopItemRenderer ;
			for(var i:int = 0 ; i<_content.numChildren ; ++i)
			{
				item = _content.getChildAt(i) as ShopItemRenderer ;
				if( item && item.baseVO && item.baseVO.name==buildName ){
					_scroll.scrollToItem( item , false );
					break ;
				}
			}
		}
	}
}