package local.views.bottom
{
	import bing.components.button.BaseButton;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import local.comm.GameData;
	import local.enum.AvatarAction;
	import local.enum.BuildingOperation;
	import local.model.PlayerModel;
	import local.utils.CharacterManager;
	import local.utils.CollectQueueUtil;
	import local.utils.PopUpManager;
	import local.utils.SoundManager;
	import local.views.shop.ShopPopUp;
	import local.views.tooltip.GameToolTip;
	
	public class ToolBox extends Sprite
	{
		public var btnMultiTool:BaseButton ;
		public var btnCancelTool:BaseButton;
		public var btnShopTool:BaseButton;
		public var btnBagTool:BaseButton ;
		public var btnReturnHome:BaseButton;
		public var toolsMenuAnim:ToolsMenuAnim;
		public var storageMenuAnim:StorageMenuAnim;
		//-----------------------------------------------*
		private var _btnMultiToolTooltip:String="TOOLS: Click to switch to the default tool and view move, rotate, and sell tools.";
		private var _btnCancelToolTooltip:String="CANCEL: Click to switch to the default tool and cancel all actions";
		private var _btnShopToolTooltip:String="SHOP: Click to shop for buildings, decorations and more for your city.";
		private var _btnBagToolTooltip:String="STORAGE: Click to see all the gifts and goodies you have received.";
		//-----------------------------------------------*
		
		public function ToolBox()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE , addedToStageHandler);
		}
		
		private function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			init();
			configListeners();
		}
		
		private function init():void
		{
			GameToolTip.instance.register(btnMultiTool,stage,_btnMultiToolTooltip);
			GameToolTip.instance.register(btnCancelTool,stage,_btnCancelToolTooltip);
			GameToolTip.instance.register(btnShopTool,stage,_btnShopToolTooltip);
			GameToolTip.instance.register(btnBagTool,stage,_btnBagToolTooltip);
		}
		
		/**
		 * 改变显示状态 
		 * @param isHome
		 */		
		public function changeState( isHome:Boolean):void
		{
			toolsMenuAnim.visible = false ;
			storageMenuAnim.visible=false;
			if( isHome){
				btnReturnHome.visible = false ;
				btnBagTool.visible = true ;
				btnShopTool.visible = true ;
			}else{
				btnReturnHome.visible = true ;
				btnBagTool.visible = false ;
				btnShopTool.visible = false ;
			}
		}
		
		private function configListeners():void
		{
			this.addEventListener(MouseEvent.CLICK , onClickHandler );
		}
		private function onClickHandler(e:MouseEvent ):void
		{
			e.stopPropagation();
			SoundManager.instance.playSoundClick();
			switch( e.target )
			{
				case btnMultiTool:
					if( GameData.buildingCurrOperation==BuildingOperation.NONE){
						toolsMenuAnim.visible = true ;
						toolsMenuAnim.gotoAndPlay(2);
					}else{
						GameData.buildingCurrOperation=BuildingOperation.NONE ;
					}
					break ;
				case btnCancelTool:
					GameData.buildingCurrOperation=BuildingOperation.NONE ;
					if(CharacterManager.instance.hero.currentActions==AvatarAction.WALK){
						CharacterManager.instance.hero.stopMove();
						CollectQueueUtil.instance.clear(true);
					}else{
						CollectQueueUtil.instance.clear();
					}
					break ;
				case btnShopTool:
					GameData.buildingCurrOperation=BuildingOperation.NONE ;
					var shopPop:ShopPopUp = new ShopPopUp();
					PopUpManager.instance.addQueuePopUp( shopPop );
					break ;
				case btnBagTool:
					if( GameData.buildingCurrOperation==BuildingOperation.NONE){
						storageMenuAnim.visible = true ;
						storageMenuAnim.gotoAndPlay(2);
					}else{
						GameData.buildingCurrOperation=BuildingOperation.NONE ;
					}
					break ;
				case btnReturnHome:
					PlayerModel.instance.getPlayer( GameData.me_uid , GameData.currentMapId );
					break ;
			}
		}
	}
}