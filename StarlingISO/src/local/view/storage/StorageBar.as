package local.view.storage
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Sine;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.Scroller;
	import feathers.controls.TabBar;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.display.TiledImage;
	import feathers.layout.HorizontalLayout;
	
	import flash.utils.Dictionary;
	
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.comm.StyleSetting;
	import local.enum.VillageMode;
	import local.model.CompsModel;
	import local.model.StorageModel;
	import local.util.EmbedManager;
	import local.view.base.BaseView;
	import local.view.base.GameButton;
	import local.vo.StorageBuildingVO;
	
	import org.osmf.layout.LayoutMode;
	
	import starling.display.Image;
	import starling.events.Event;
	
	/**
	 * 收藏箱 
	 * @author zhouzhanglin
	 */	
	public class StorageBar extends BaseView
	{
		private static var _instance:StorageBar;
		public static function get instance():StorageBar{
			if(!_instance) _instance = new StorageBar();
			return _instance ;
		}
		public var btnClose:GameButton ;
		private var _list:List ;
		private var _count:int ;
		
		public var menuBar:TabBar;
		
		public function StorageBar()
		{
			super();
			init();
		}
		
		private function init():void
		{
			var tileImg:TiledImage = new TiledImage( EmbedManager.getUITexture("StorageTileBg"));
			tileImg.setSize(GameSetting.SCREEN_WIDTH,334*GameSetting.GAMESCALE);
			addChild(tileImg);
				
			var title:Image = EmbedManager.getUIImage("StorageTitle_en");
			title.x = (GameSetting.SCREEN_WIDTH-title.width)>>1 ;
			title.y = -10*GameSetting.GAMESCALE-title.height>>1 ;
			addChild(title) ;
			
			var img:Image = StyleSetting.POPUP_CLOSE_BTN() ;
			btnClose = new GameButton( img );
			btnClose.x = GameSetting.SCREEN_WIDTH - img.width*0.5-10*GameSetting.GAMESCALE ;
			addChild(btnClose);
			btnClose.onRelease.add( onClickClose);
			
			_list = new List();
			_list.width = _list.maxWidth = GameSetting.SCREEN_WIDTH-30*GameSetting.GAMESCALE ;
			_list.x = 15*GameSetting.GAMESCALE ;
			_list.y = 115*GameSetting.GAMESCALE ;
			_list.height = 215*GameSetting.GAMESCALE;
			_list.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			_list.itemRendererFactory = function():IListItemRenderer {
				return new StorageItemRenderer();
			};
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.gap = 10 ;
			layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_TOP ;
			_list.layout = layout;
			addChild(_list);
			
			
			this.menuBar = new TabBar();
			menuBar.direction = LayoutMode.HORIZONTAL;
			menuBar.tabInitializer = tabInitializer ;
			menuBar.gap = 5*GameSetting.GAMESCALE ;
			this.menuBar.onChange.add(tabBar_onChange);
			this.addChild(this.menuBar);
			this.menuBar.dataProvider = new ListCollection(
				[
					"All", "Home","Business","Decor","Industry","Community","Wonders","Comp"
				]);
			menuBar.width = menuBar.maxWidth = GameSetting.SCREEN_WIDTH-100*GameSetting.GAMESCALE ;
			menuBar.y= 42*GameSetting.GAMESCALE ;
			menuBar.x = 10*GameSetting.GAMESCALE ;
		}
		
		private function tabInitializer(tab:Button , item:String ):void
		{
			tab.defaultSkin = new Image(StyleSetting.StorageTabBtnUpTexutre) ;
			tab.downSkin = new Image(StyleSetting.StorageTabBtnSelectedTexutre) ;
			tab.selectedUpSkin = new Image(StyleSetting.StorageTabBtnSelectedTexutre) ;
			tab.defaultIcon = EmbedManager.getUIImage("Storage"+item+"ButtonIcon") ;
		}
		
		private function tabBar_onChange(tabBar:TabBar):void
		{
			switch(tabBar.selectedItem){
				case "All":
					var temp:Array = [] ;
					if(StorageModel.instance.homes)  for each( var vo:StorageBuildingVO in StorageModel.instance.homes) temp.push( vo );
					if(StorageModel.instance.business)  for each( vo in StorageModel.instance.business) temp.push( vo );
					if(StorageModel.instance.industry)  for each( vo in StorageModel.instance.industry) temp.push( vo );
					if(StorageModel.instance.wonders)  for each( vo in StorageModel.instance.wonders) temp.push( vo );
					if(StorageModel.instance.community)  for each( vo in StorageModel.instance.community) temp.push( vo );
					if(StorageModel.instance.decors)  for each( vo in StorageModel.instance.decors) temp.push( vo );
					var comps:Array = getComps();
					if(comps) temp = temp.concat(comps);
					_list.dataProvider = new ListCollection( temp) ;
					break ;
				case "Home":
					_list.dataProvider = new ListCollection( StorageModel.instance.homes) ;
					break;
				case "Business":
					_list.dataProvider = new ListCollection( StorageModel.instance.business );
					break;
				case "Industry":
					_list.dataProvider = new ListCollection( StorageModel.instance.industry );
					break;
				case "Wonders":
					_list.dataProvider = new ListCollection( StorageModel.instance.wonders );
					break;
				case "Community":
					_list.dataProvider = new ListCollection( StorageModel.instance.community );
					break;
				case "Decor":
					_list.dataProvider = new ListCollection(StorageModel.instance.decors );
					break;
				case "Comp":
					_list.dataProvider = new ListCollection(getComps());
					break;
				
			}
		}
		
		private function getComps():Array
		{
			var myComps:Dictionary = CompsModel.instance.myComps ;
			if(myComps){
				var data:Array = [];
				for ( var key:String in myComps)
				{
					data.push( key );
				}
				return data;
			}
			return null ;
		}
		
		private function onClickClose( btn:GameButton):void{
			close();
		}
		
		private function close():void
		{
			touchable = false ;
			TweenLite.to( this , 0.25 , { y:0 , onComplete:tweenOver} ) ;
		}
		
		private function tweenOver():void{
			if(parent){
				parent.removeChild(this);
			}
			GameData.villageMode = VillageMode.EDIT ;
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			
			x = ( GameSetting.SCREEN_WIDTH-width)>>1 ;
			y=0;
			TweenLite.to( this , 0.25 , { y:-334*GameSetting.GAMESCALE , onComplete: function():void{ 
				touchable = true ;
			} ,ease:Sine.easeOut  });
			
			menuBar.selectedItem = "All";
			tabBar_onChange(menuBar);
		}
		
		override protected function removedFromStageHandler(e:Event):void
		{
			super.removedFromStageHandler(e);
		}
	}
}