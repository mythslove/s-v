package local.view.bottom
{
	import com.greensock.TweenLite;
	
	import flash.utils.setTimeout;
	
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.map.item.BaseItem;
	import local.util.EmbedManager;
	import local.view.base.GameButton;
	import local.view.shop.ShopBar;
	import local.view.storage.StorageBar;
	
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
			btnMarket.x = GameSetting.SCREEN_WIDTH - btnMarket.pivotX-5 ;
			btnMarket.y = -btnMarket.pivotY-5 ;
			addChild(btnMarket);
			btnMarket.addEventListener(Event.TRIGGERED , onClickHandler );
			
			img = EmbedManager.getUIImage("EditorButton");
			btnEditor = new GameButton(img);
			btnEditor.x = btnMarket.x-img.width-50 ;
			btnEditor.y = -btnEditor.pivotY-5;
			addChild( btnEditor );
			btnEditor.addEventListener(Event.TRIGGERED , onClickHandler );
			
			img = EmbedManager.getUIImage("MenuButton");
			btnMenu = new GameButton(img);
			btnMenu.x = img.width*0.5+5 ;
			btnMenu.y = -btnMenu.pivotY-5;
			addChild( btnMenu );
			btnMenu.addEventListener(Event.TRIGGERED , onClickHandler );
			
			img = EmbedManager.getUIImage("StorageButton");
			btnStorage = new GameButton(img);
			btnStorage.x = btnStorage.pivotX+5;
			btnStorage.y = -btnStorage.pivotY-5;
			btnStorage.setVisible( false );
			addChild( btnStorage );
			btnStorage.addEventListener(Event.TRIGGERED , onClickHandler );
			
			img = EmbedManager.getUIImage("DoneButton");
			btnDone = new GameButton(img);
			btnDone.x = GameSetting.SCREEN_WIDTH - btnDone.pivotX-5 ;
			btnDone.y = -btnDone.pivotY-5;
			btnDone.setVisible( false );
			addChild( btnDone );
			btnDone.addEventListener(Event.TRIGGERED , onClickHandler );
		}
		
		private function onClickHandler( e:Event ):void
		{
			switch( e.target )
			{
				case btnMarket:
					showShop();
					break ;
				case btnEditor:
					GameData.villageMode = VillageMode.EDIT ;
					break ;
				case btnDone:
					if(GameData.villageMode==VillageMode.EXPAND){
						GameWorld.instance.topScene.clear();
					}else{
						checkTopSceneBuilding();
					}
					GameData.villageMode = VillageMode.NORMAL ;
					break ;
				case btnStorage:
					showStorage();
					break ;
			}
		}
		
		
		
		
		
		
		private function checkTopSceneBuilding():void
		{
			var world:GameWorld = GameWorld.instance ;
			if( world.topScene.numChildren>0){
				var item:BaseItem = world.topScene.getChildAt(0) as BaseItem;
				if( item ){
					item.nodeX = BaseItem.cachePos.x ;
					item.nodeZ = BaseItem.cachePos.y ;
					item.addToWorldFromTopScene();
//					if(EditorItemButtons.instance.parent){
//						EditorItemButtons.instance.parent.removeChild( EditorItemButtons.instance );
//					}
				}
			}
		}
		
		/**
		 * 显示收藏箱 
		 */		
		public function showStorage():void
		{
			btnStorage.visible = btnDone.visible = btnMarket.visible=btnEditor.visible=btnMenu.visible = false ;
			checkTopSceneBuilding();
			setTimeout( function():void{
				addChild(StorageBar.instance);
			},200);
		}
		/**
		 * 显示商店 
		 */		
		public function showShop():void{
			btnMarket.visible=btnEditor.visible=btnMenu.visible = false ;
			setTimeout( function():void{
				addChild(ShopBar.instance);
			},200);
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