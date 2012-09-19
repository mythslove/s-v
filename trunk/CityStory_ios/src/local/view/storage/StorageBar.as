package local.view.storage
{
	import bing.utils.ContainerUtil;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Sine;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import local.comm.GameData;
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.map.item.BaseBuilding;
	import local.model.ComponentModel;
	import local.model.ShopModel;
	import local.model.StorageModel;
	import local.util.BuildingFactory;
	import local.view.base.BaseView;
	import local.view.btn.MiniCloseButton;
	import local.view.control.ScrollControllerH;
	import local.view.control.ToggleBar;
	import local.view.control.ToggleBarEvent;
	import local.vo.BaseBuildingVO;
	import local.vo.StorageBuildingVO;
	
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
		//==================================
		public var container:Sprite ;
		public var btnClose:MiniCloseButton ;
		//============================
		protected var _scroll:ScrollControllerH = new ScrollControllerH() ;
		protected var _content:Sprite = new Sprite() ;
		private var _btns:Vector.<MovieClip> ;
		private var _renderPool:Array ;
		private var _count:int ;
		
		public var menuBar:ToggleBar;
		
		public function StorageBar()
		{
			super();
			init();
			addEventListener(MouseEvent.CLICK , onClickHandler );
		}
		
		private function init():void
		{
			container.graphics.beginFill(0,0);
			container.graphics.drawRect(0,0,940,180);
			container.graphics.endFill();
			
			menuBar = new ToggleBar();
			_btns= Vector.<MovieClip>([
				new StorageMenuButton("all") ,new StorageMenuButton("home"),new StorageMenuButton("business") ,new StorageMenuButton("decor"),
				new StorageMenuButton("industry") ,new StorageMenuButton("community"),new StorageMenuButton("wonder") ,new StorageMenuButton("comp")
			]);
			menuBar.buttons = _btns ;
			addChild(menuBar);
			menuBar.x = 10 ;
			menuBar.y= 65 ;
			menuBar.addEventListener(ToggleBarEvent.TOGGLE_CHANGE , toggleChangeHandler);
		}
		
		private function toggleChangeHandler( e:ToggleBarEvent ):void
		{
			ContainerUtil.removeChildren(_content);
			_scroll.removeScrollControll();
			
			_count = 0 ;
			if(e.selectedName=="all" || e.selectedName=="home"){
				if(StorageModel.instance.homes) addStorageItems( StorageModel.instance.homes );
			}
			if(e.selectedName=="all" || e.selectedName=="business"){
				if(StorageModel.instance.business)addStorageItems( StorageModel.instance.business );
			}
			if(e.selectedName=="all" || e.selectedName=="industry"){
				if(StorageModel.instance.industry) addStorageItems( StorageModel.instance.industry );
			}
			if(e.selectedName=="all" || e.selectedName=="wonder"){
				if(StorageModel.instance.wonders) addStorageItems( StorageModel.instance.wonders );
			}
			if(e.selectedName=="all" || e.selectedName=="community"){
				if(StorageModel.instance.community) addStorageItems( StorageModel.instance.community );
			}
			if(e.selectedName=="all" || e.selectedName=="decor"){
				if(StorageModel.instance.decors) addStorageItems( StorageModel.instance.decors );
			}
			if(e.selectedName=="all" || e.selectedName=="comp"){
				addComps();
			}
			
			_scroll.addScrollControll( _content , container );
			container.addChild(_content);
		}
		
		
		private function addStorageItems( items:Vector.<StorageBuildingVO> ):void
		{
			var render:StorageItemRenderer ;
			var len:int = items.length ;
			for( var i:int = 0 ; i<len ; ++i )
			{
				render = getStorageRender(items[i] , i+_count );
				render.x = (i+_count)*140 ;
				_content.addChild( render );
			}
			_count+=len ;
		}
		
		private function addComps( count:int=0 ):void
		{
			if( ComponentModel.instance.myComps){
				
			}
		}
		
		private function getStorageRender( vo:Object , index:int  ):StorageItemRenderer
		{
			if(!_renderPool) _renderPool = [];
			
			var render:StorageItemRenderer ;
			if(_renderPool.length>index){
				render = _renderPool[index] ;
			}else{
				render = new StorageItemRenderer();
				_renderPool.push( render );
			}
			render.vo = vo ;
			return render ;
		}
		
		private function onClickHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			if(e.target==btnClose){
				close();
			}else if(e.target is StorageMenuButton){
				menuBar.selected = e.target as StorageMenuButton;
			}else if( e.target is StorageItemRenderer){
				
				var render:StorageItemRenderer = e.target as StorageItemRenderer ;
				var stvo:StorageBuildingVO = render.vo as StorageBuildingVO ;
				var building:BaseBuilding = BuildingFactory.createBuildingByBaseVO(  ShopModel.instance.allBuildingHash[stvo.name] as BaseBuildingVO );
				GameWorld.instance.addBuildingToTopScene( building);
				
				if(parent){
					parent.removeChild(this);
				}
			}
		}
		
		private function close():void
		{
			mouseChildren = false ;
			TweenLite.to( this , 0.25 , {y:0 , onComplete:tweenOver} ) ;
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
			menuBar.selected = _btns[0];
			
			y=0;
			TweenLite.to( this , 0.3 , { y:-height+15 , onComplete: function():void{ 
				mouseChildren = true ;
			} ,ease:Sine.easeOut  });
		}
		
		override protected function removedFromStageHandler(e:Event):void
		{
			super.removedFromStageHandler(e);
		}
	}
}