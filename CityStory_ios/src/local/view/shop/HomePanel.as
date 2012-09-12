package local.view.shop
{
	import bing.utils.ContainerUtil;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import local.comm.GameData;
	import local.enum.BuildingType;
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.map.item.BaseBuilding;
	import local.model.ShopModel;
	import local.util.BuildingFactory;
	import local.util.PopUpManager;
	import local.view.btn.TabMenuButton;
	import local.view.control.ScrollControllerH;
	import local.view.control.ToggleBar;
	import local.view.control.ToggleBarEvent;
	
	public class HomePanel extends Sprite
	{
		private static var _instance:HomePanel;
		public static function get instance():HomePanel{
			if(!_instance) _instance = new HomePanel();
			return _instance ;
		}
		//=====================================
		
		public var mainTypeBar:ToggleBar;
		public var container:Sprite ;
		
		private var _scroll:ScrollControllerH = new ScrollControllerH() ;
		private var _scrollContainer:Sprite = new Sprite() ;
		
		public function HomePanel()
		{
			super();
			init();
		}
		
		private function init():void
		{
			container = new Sprite();
			container.x = 5 ;
			container.y = 130 ;
			container.graphics.beginFill(0,0);
			container.graphics.drawRect(0,0,830,360);
			container.graphics.endFill();
			addChild(container);
			
			mainTypeBar = new ToggleBar();
			var mcs:Vector.<MovieClip>= Vector.<MovieClip>([
				new TabMenuButton("ALL") ,new TabMenuButton("RESIDENCE"),new TabMenuButton("CONDOS") ,new TabMenuButton("MANSIONS") 
			]);
			mainTypeBar.buttons = mcs ;
			addChild(mainTypeBar);
			mainTypeBar.x = 10 ;
			mainTypeBar.y= 10 ;
			mainTypeBar.addEventListener(ToggleBarEvent.TOGGLE_CHANGE , toggleChangeHandler);
			mainTypeBar.selected = mcs[0];
			
			_scrollContainer.addEventListener(MouseEvent.CLICK , onItemHandler );
		}
		
		private function toggleChangeHandler( e:ToggleBarEvent ):void
		{
			ContainerUtil.removeChildren(_scrollContainer);
			_scroll.removeScrollControll();
			
			var homeRenders:Vector.<ShopItemRenderer> = ShopModel.instance.homesRenderers ;
			if(!homeRenders) return ;
			var len:int =homeRenders.length ,  count:int , cop:int=5 ;
			var render:ShopItemRenderer ;
			for( var i:int = 0 ; i <len ; ++i ) {
				render = homeRenders[i] ;
				if(e.selectedName=="ALL"){
					render.x = (render.width+cop)*count ;
					_scrollContainer.addChild( render );
					++count ;
				}
				else if(e.selectedName=="RESIDENCE"){
					if( render.baseVO.subClass==BuildingType.HOME_RESIDENCE){
						render.x = (render.width+cop)*count ;
						_scrollContainer.addChild( render );
						++count ;
					}
				}
				else if(e.selectedName=="CONDOS"){
					if( render.baseVO.subClass==BuildingType.HOME_CONDOS){
						render.x = (render.width+cop)*count ;
						_scrollContainer.addChild( render );
						++count ;
					}
				}
				else if(e.selectedName=="MANSIONS"){
					if( render.baseVO.subClass==BuildingType.HOME_MANSIONS){
						render.x = (render.width+cop)*count ;
						_scrollContainer.addChild( render );
						++count ;
					}
				}
			}
			_scroll.addScrollControll( _scrollContainer , container , new Rectangle(0,0,830,360));
			container.addChild(_scrollContainer);
		}
		
		
		private function onItemHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			if(e.target is ShopItemRenderer)
			{
				var render:ShopItemRenderer = e.target as ShopItemRenderer ;
				var building:BaseBuilding = BuildingFactory.createBuildingByBaseVO( render.baseVO );
				
				GameWorld.instance.addBuildingToTopScene( building);
				GameData.villageMode=VillageMode.BUILDING_SHOP ;
				PopUpManager.instance.removeCurrentPopup();
			}
		}
	}
}