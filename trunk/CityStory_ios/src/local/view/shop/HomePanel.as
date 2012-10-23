package local.view.shop
{
	import bing.utils.ContainerUtil;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import local.comm.GameData;
	import local.enum.BuildingType;
	import local.model.ShopModel;
	import local.view.btn.TabMenuButton;
	import local.view.control.ToggleBar;
	import local.view.control.ToggleBarEvent;
	
	public class HomePanel extends ShopPanel
	{
		private static var _instance:HomePanel;
		public static function get instance():HomePanel{
			if(!_instance) _instance = new HomePanel();
			return _instance ;
		}
		//=====================================
		public static const TAB_ALL:String = "ALL";
		public static const  TAB_RESIDENCE:String = "RESIDENCE";
		public static const  TAB_CONDOS:String = "CONDOS";
		public static const  TAB_MANSIONS:String = "MANSIONS";
		
		public var mainTypeBar:ToggleBar;
		
		public function HomePanel()
		{
			super();
			init();
		}
		
		private function init():void
		{
			mainTypeBar = new ToggleBar(15);
			var mcs:Vector.<MovieClip>= Vector.<MovieClip>([
				new TabMenuButton(TAB_ALL) ,new TabMenuButton(TAB_RESIDENCE),new TabMenuButton(TAB_CONDOS) ,new TabMenuButton(TAB_MANSIONS) 
			]);
			mainTypeBar.buttons = mcs ;
			addChild(mainTypeBar);
			mainTypeBar.x =x + (888-mainTypeBar.width)>>1 ; //30
			mainTypeBar.addEventListener(ToggleBarEvent.TOGGLE_CHANGE , toggleChangeHandler);
			mainTypeBar.selected = mcs[0];
		}
		
		private function toggleChangeHandler( e:ToggleBarEvent ):void
		{
			ContainerUtil.removeChildren(_content);
			_scroll.removeScrollControll();
			_scroll.addScrollControll( _content , container , 3 ,20 );
			if(GameData.isShowTutor){
				_scroll.scrollLock = true ;
			}else{
				_scroll.scrollLock = false ;
			}
			
			var itemRenders:Vector.<ShopItemRenderer> = ShopModel.instance.homesRenderers ;
			if(!itemRenders) return ;
			var len:int =itemRenders.length  ;
			var render:ShopItemRenderer ;
			for( var i:int = 0 ; i <len ; ++i ) {
				render = itemRenders[i] ;
				if(e.selectedName==TAB_ALL){
					_scroll.addItem( render );
				}
				else if(e.selectedName==TAB_RESIDENCE){
					if( render.baseVO.subClass==BuildingType.HOME_RESIDENCE){
						_scroll.addItem( render );
					}
				}
				else if(e.selectedName==TAB_CONDOS){
					if( render.baseVO.subClass==BuildingType.HOME_CONDOS){
						_scroll.addItem( render );
					}
				}
				else if(e.selectedName==TAB_MANSIONS){
					if( render.baseVO.subClass==BuildingType.HOME_MANSIONS){
						_scroll.addItem( render );
					}
				}
			}
			refreshPageButton();
		}
		
		
		override protected function onItemHandler( e:MouseEvent ):void
		{
			super.onItemHandler(e);
			if(e.target is ShopItemRenderer)
			{
				var render:ShopItemRenderer = e.target as ShopItemRenderer ;
				if( checkMoney(render)){
					addItemToWorld( render );
				}
			}
		}
	}
}