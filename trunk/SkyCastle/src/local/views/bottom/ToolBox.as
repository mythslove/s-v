package local.views.bottom
{
	import bing.components.button.BaseButton;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import local.comm.GameData;
	import local.enum.BuildingOperation;
	import local.utils.PopUpManager;
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
			
			btnReturnHome.visible = false ;
			toolsMenuAnim.visible = false ;
		}
		
		private function configListeners():void
		{
			this.addEventListener(MouseEvent.CLICK , onClickHandler );
		}
		private function onClickHandler(e:MouseEvent ):void
		{
			e.stopPropagation();
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
					break ;
				case btnShopTool:
					GameData.buildingCurrOperation=BuildingOperation.NONE ;
					var shopPop:ShopPopUp = new ShopPopUp();
					PopUpManager.instance.addQueuePopUp( shopPop );
					break ;
				case btnBagTool:
					GameData.buildingCurrOperation=BuildingOperation.NONE ;
					break ;
			}
		}
	}
}