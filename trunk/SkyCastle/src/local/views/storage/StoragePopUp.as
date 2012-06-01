package local.views.storage
{
	import bing.components.button.BaseButton;
	import bing.components.events.ToggleItemEvent;
	import bing.utils.ContainerUtil;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.comm.GlobalDispatcher;
	import local.enum.BuildingOperation;
	import local.enum.ItemType;
	import local.events.StorageEvent;
	import local.game.GameWorld;
	import local.game.elements.Building;
	import local.model.PickupModel;
	import local.model.StorageModel;
	import local.model.buildings.vos.BuildingVO;
	import local.model.vos.PickupVO;
	import local.model.vos.StorageItemVO;
	import local.utils.BuildingFactory;
	import local.utils.PopUpManager;
	import local.utils.SoundManager;
	import local.views.base.BaseView;
	import local.views.loading.SkinLoading;

	/**
	 * 收藏箱弹出窗口 
	 * @author zzhanglin
	 */	
	public class StoragePopUp extends BaseView
	{
		public var tabMenu:StorageMainTab;
		public var btnClose:BaseButton;
		public var container:Sprite;
		public var btnPrevPage:BaseButton;
		public var btnNextPage:BaseButton;
		//==============================
		//缓存收藏箱查看的位置，以便下次进来还是显示上次的位置
		public static var storageCurrentTab:String ; 
		public static var storageCurrentPage:int = 0  ;
		//===================================
		private var _dataProvider:Vector.<StorageItemVO>; 
		private var _materials:Array ;
		private const COUNT:int = 8 ;//一页显示八个
		private var _totalPage:int ;
		private var _page:int ;
		private var _loading:SkinLoading ;
		
		public function StoragePopUp()
		{
			super();
			tabMenu.visible=false ;
			btnNextPage.enabled=btnPrevPage.enabled=false ;
			x = GameSetting.SCREEN_WIDTH>>1;
			y = GameSetting.SCREEN_HEIGHT>>1;
			_loading = new SkinLoading();
			addChild(_loading);
		}
		
		override protected function added():void
		{
			TweenLite.from(this,0.3,{x:x-200 , ease:Back.easeOut });
			SoundManager.instance.playSoundPopupShow();
			btnClose.addEventListener( MouseEvent.CLICK , closeClickHandler , false , 0 , true );
			tabMenu.addEventListener(ToggleItemEvent.ITEM_SELECTED , tabMenuHandler , false , 0 , true ) ;
			btnPrevPage.addEventListener(MouseEvent.CLICK , pageBtnHandler , false , 0 , true );
			btnNextPage.addEventListener(MouseEvent.CLICK , pageBtnHandler , false , 0 , true );
			GlobalDispatcher.instance.addEventListener(StorageEvent.SELECTED_BUILDING , storageEventHandler );
			GlobalDispatcher.instance.addEventListener(StorageEvent.GET_STROAGE_ITEMS , storageEventHandler );
			StorageModel.instance.getStorageItems();
		}
		
		private function storageEventHandler( e:StorageEvent ):void
		{
			switch( e.type )
			{
				case  StorageEvent.SELECTED_BUILDING:
					GameData.buildingCurrOperation = BuildingOperation.PLACE_STASH ;
					var building:Building = BuildingFactory.createBuildingByVO(BuildingVO.createVoByStorageItem(e.selectedBuilding));
					GameWorld.instance.addBuildingToTop( building );
					PopUpManager.instance.removeCurrentPopup();
					break ;
				case StorageEvent.GET_STROAGE_ITEMS:
					removeChild(_loading);
					tabMenu.visible=true ;
					if(storageCurrentTab){
						tabMenu.selectedName = storageCurrentTab;
					}else{
						tabMenu.selectedName = tabMenu.btnBuilding.name;
					}
					break ;
			}
		}

		/* 收藏箱中的页码*/
		private function pageBtnHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			SoundManager.instance.playSoundClick();
			switch( e.target)
			{
				case btnPrevPage:
					_page--;
					break ;
				case btnNextPage:
					_page++;
					break;
			}
			if(tabMenu.selectedName==tabMenu.btnMaterial.name){
				this.showMaterials(_page);
			}else{
				showBuildingList(_page);
			}
		}
		/* 主分类菜单按钮单击*/
		private function tabMenuHandler( e:ToggleItemEvent):void 
		{
			storageCurrentTab=e.selectedName;
			ContainerUtil.removeChildren( container );
			switch(  e.selectedName )
			{
				case tabMenu.btnBuilding.name:
					setDataProvider( StorageModel.instance.buildings);
					showBuildingList(0);
					break ;
				case tabMenu.btnDecoration.name:
					setDataProvider( StorageModel.instance.decorations);
					showBuildingList(0);
					break ;
				case tabMenu.btnPlant.name:
					setDataProvider( StorageModel.instance.plants);
					showBuildingList(0);
					break ;
				case tabMenu.btnMaterial.name:
					setMaterials();
					showMaterials(0);
					break ;
			}
		}
		/*显示收藏箱中的建筑*/
		private function setDataProvider( value:Vector.<StorageItemVO> ):void
		{
			_dataProvider = value ;
			_page = 0 ;
			_totalPage = 0 ;
			if(value){
				_totalPage = Math.ceil(value.length/COUNT);
			}
		}
		/*显示材料*/
		private function setMaterials():void
		{
			var pks:Object = PickupModel.instance.myPickups ;
			var pkvo:PickupVO ;
			_materials = [];
			if(pks){
				for( var key:String in pks){
					pkvo = PickupModel.instance.getPickupById(key) ;
					if(pkvo.type==ItemType.PICKUP_MATERIAL)	 _materials.push( key );
				}
			}
			_page = 0 ;
			_totalPage = Math.ceil(_materials.length/COUNT);
		}
		
		private function showBuildingList( page:int ):void
		{
			StoragePopUp.storageCurrentPage = page ;
			ContainerUtil.removeChildren(container);
			if(_dataProvider==null) return ;
			_page = page ;
			var render:StorageItemRenderer ;
			var len:int = _dataProvider.length;
			var col:int = 4 ;
			var temp:int = 0 ;
			for( var i:int = _page*COUNT ; i<len && i<_page*COUNT+COUNT ; ++i )
			{
				render = new StorageItemRenderer();
				render.x = (temp%col)*(render.width + 10);
				render.y = Math.floor(temp/col)*(render.height+20);
				container.addChild(render);
				render.showBuilding( _dataProvider[i] );
				temp++;
			}
			updatePageButton();
		}
		
		private function showMaterials( page:int ):void
		{
			StoragePopUp.storageCurrentPage = page ;
			ContainerUtil.removeChildren(container);
			if(_materials==null) return ;
			_page = page ;
			var render:StorageItemRenderer ;
			var len:int = _materials.length;
			var col:int = 4 ;
			var temp:int = 0 ;
			for( var i:int = _page*COUNT ; i<len && i<_page*COUNT+COUNT ; ++i )
			{
				render = new StorageItemRenderer();
				render.x = (temp%col)*(render.width + 10);
				render.y = Math.floor(temp/col)*(render.height+20);
				container.addChild(render);
				render.showMaterial( _materials[i] );
				temp++;
			}
			updatePageButton();
		}
		
		private function updatePageButton():void
		{
			if(_totalPage==0){
				btnNextPage.enabled=btnPrevPage.enabled=false ;
			}else{
				btnNextPage.enabled=btnPrevPage.enabled=true ;
				if(_page==_totalPage-1){
					btnNextPage.enabled = false;
				}
				if(_page==0){
					btnPrevPage.enabled = false ;
				}
			}
		}
		
		
		
		
		//==============释放=======================
		private function closeClickHandler( e:MouseEvent ):void
		{
			mouseChildren = false ;
			container.visible=false;
			TweenLite.to(this,0.3,{x:x+200 , ease:Back.easeIn , onComplete:tweenComplete});
			SoundManager.instance.playSoundClick();
		}
		
		private function tweenComplete():void {
			PopUpManager.instance.removeCurrentPopup(); 
		}
		
		override protected function removed():void
		{
			_loading = null ;
			btnClose.removeEventListener( MouseEvent.CLICK , closeClickHandler);
			tabMenu.removeEventListener(ToggleItemEvent.ITEM_SELECTED , tabMenuHandler ) ;
			btnPrevPage.removeEventListener(MouseEvent.CLICK , pageBtnHandler );
			btnNextPage.removeEventListener(MouseEvent.CLICK , pageBtnHandler );
			GlobalDispatcher.instance.removeEventListener(StorageEvent.SELECTED_BUILDING , storageEventHandler );
			GlobalDispatcher.instance.removeEventListener(StorageEvent.GET_STROAGE_ITEMS , storageEventHandler );
		}
	}
}