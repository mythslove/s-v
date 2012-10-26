package local.view.bottom
{
	import com.greensock.TweenLite;
	
	import local.comm.GameSetting;
	import local.util.EmbedManager;
	import local.view.base.GameButton;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class BottomBar extends Sprite
	{
		public var btnMarket:GameButton ;
		public var btnEditor:GameButton ;
		public var btnDone:GameButton ;
		public var btnStorage:GameButton ;
		public var btnMenu:GameButton; 
		
		public function BottomBar()
		{
			super();
			init();
		}
		
		private function init():void
		{
			var img:Image =EmbedManager.getUIImage("ShopButton");
			btnMarket = new GameButton(img);
			btnMarket.x = GameSetting.SCREEN_WIDTH - btnMarket.pivotX-10 ;
			btnMarket.y = -btnMarket.pivotY-5 ;
			addChild(btnMarket);
			btnMarket.addEventListener(Event.TRIGGERED , onClickHandler );
			
			img = EmbedManager.getUIImage("EditorButton");
			btnEditor = new GameButton(img);
			btnEditor.x = btnMarket.x-img.width-70 ;
			btnEditor.y = -btnEditor.pivotY-5;
			addChild( btnEditor );
			btnEditor.addEventListener(Event.TRIGGERED , onClickHandler );
			
			img = EmbedManager.getUIImage("MenuButton");
			btnMenu = new GameButton(img);
			btnMenu.x = img.width*0.5+10 ;
			btnMenu.y = -btnEditor.pivotY-5;
			addChild( btnMenu );
			btnMenu.addEventListener(Event.TRIGGERED , onClickHandler );
			
//			img = EmbedManager.getUIImage("BottomBarStorageButtonUp");
//			btnStorage = new GameButton(img);
//			btnStorage.x = btnStorage.pivotX+5;
//			btnStorage.y = -btnStorage.pivotY-5;
//			btnStorage.setVisible( false );
//			addChild( btnStorage );
//			btnStorage.addEventListener(Event.TRIGGERED , onClickHandler );
//			
//			img = EmbedManager.getUIImage("DoneButtonUp");
//			btnDone = new GameButton(img);
//			btnDone.x = GameSetting.SCREEN_WIDTH - btnDone.pivotX-5 ;
//			btnDone.y = -btnDone.pivotY-5;
//			btnDone.setVisible( false );
//			addChild( btnDone );
//			btnDone.addEventListener(Event.TRIGGERED , onClickHandler );
		}
		
		private function onClickHandler( e:Event ):void
		{
//			switch( e.target )
//			{
//				case btnMarket:
//					PopUpManager.instance.addQueuePopUp( ShopOverViewPopUp.instance , true );
//					break ;
//				case btnEditor:
//					GameData.villageMode = VillageMode.EDIT ;
//					break ;
//				case btnDone:
//					if(GameData.villageMode==VillageMode.EXPAND){
//						GameWorld.instance.topScene.clear();
//					}else{
//						checkTopSceneBuilding();
//					}
//					GameData.villageMode = VillageMode.NORMAL ;
//					break ;
//				case btnStorage:
//					checkTopSceneBuilding();
//					GameData.villageMode = VillageMode.BUILDING_STORAGE ;
//					break ;
//			}
		}
		
		
		
		
		
		
		private function checkTopSceneBuilding():void
		{
//			var world:GameWorld = GameWorld.instance ;
//			if( world.topScene.numChildren>0){
//				var building:BaseBuilding = world.topScene.getChildAt(0) as BaseBuilding;
//				if( building ){
//					building.nodeX = BaseBuilding.cachePos.x ;
//					building.nodeZ = BaseBuilding.cachePos.y ;
//					building.addToWorldFromTopScene();
//					if(EditorBuildingButtons.instance.parent){
//						EditorBuildingButtons.instance.parent.removeChild( EditorBuildingButtons.instance );
//					}
//				}
//			}
		}
		
		/**
		 * 显示收藏箱 
		 */		
		public function showStorage():void
		{
//			addChild( StorageBar.instance);
		}
		
		
		
		
		
		
		
		
		public function setVisible( value:Boolean ):void
		{
			_tempVisible = super.visible = value ;
		}
		
		private var _tempVisible:Boolean ;
		override public function set visible(value:Boolean):void
		{
			if(_tempVisible==value) return ;
			_tempVisible = value ;
			if( value){
				alpha = 0 ;
				TweenLite.to( this , 0.25 , {alpha:1 , onComplete: onTweenCom} );
			}else{
				alpha = 1 ;
				TweenLite.to( this , 0.25 , {alpha:0 , onComplete: onTweenCom} );
			}
		}
		
		private function onTweenCom():void{
			super.visible = _tempVisible ;
		}
		
	}
}