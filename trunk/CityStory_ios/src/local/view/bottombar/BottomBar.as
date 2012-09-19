package local.view.bottombar
{
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.map.item.BaseBuilding;
	import local.util.PopUpManager;
	import local.view.base.BaseView;
	import local.view.building.EditorBuildingButtons;
	import local.view.shop.ShopOverViewPopUp;
	import local.view.storage.StorageBar;
	
	public class BottomBar extends BaseView
	{
		public var editorBtn:EditorButton ;
		public var marketBtn:MarketButton;
		public var doneBtn:DoneButton ;
		public var storageBtn:StorageButton ;
		
		public function BottomBar()
		{
			super();
			mouseEnabled = false ;
		}
		
		override protected function addedToStageHandler( e:Event ):void
		{
			super.addedToStageHandler(e);
			
			marketBtn = new MarketButton();
			marketBtn.x = GameSetting.SCREEN_WIDTH-marketBtn.width-10 ;
			marketBtn.y = - marketBtn.height-10 ;
			addChild(marketBtn);
			
			
			editorBtn = new EditorButton();
			editorBtn.x = marketBtn.x-editorBtn.width-50 ;
			editorBtn.y = - editorBtn.height-10 ;
			addChild(editorBtn);
			
			doneBtn = new DoneButton();
			doneBtn.x = GameSetting.SCREEN_WIDTH-doneBtn.width-10 ;
			doneBtn.y = - doneBtn.height-10 ;
			addChild(doneBtn);
			
			storageBtn = new StorageButton();
			storageBtn.x = 10;
			storageBtn.y = - storageBtn.height-10 ;
			addChild(storageBtn);
			
			addEventListener(MouseEvent.CLICK , onMouseHandler );
		}
		
		private function onMouseHandler( e:MouseEvent):void
		{
			switch(e.target)
			{
				case editorBtn:
					GameData.villageMode = VillageMode.EDIT ;
					break ;
				case marketBtn:
					PopUpManager.instance.addQueuePopUp( ShopOverViewPopUp.instance , true , 0 , 0 );
					break ;
				case doneBtn:
					checkTopSceneBuilding();
					GameData.villageMode = VillageMode.NORMAL ;
					break ;
				case storageBtn:
					checkTopSceneBuilding();
					GameData.villageMode = VillageMode.BUILDING_STORAGE ;
					break ;
			}
		}
		
		private function checkTopSceneBuilding():void
		{
			var world:GameWorld = GameWorld.instance ;
			if( world.topScene.numChildren>0){
				var building:BaseBuilding = world.topScene.getChildAt(0) as BaseBuilding;
				if( building ){
					building.nodeX = BaseBuilding.cachePos.x ;
					building.nodeZ = BaseBuilding.cachePos.y ;
					building.addToWorldFromTopScene();
					if(EditorBuildingButtons.instance.parent){
						EditorBuildingButtons.instance.parent.removeChild( EditorBuildingButtons.instance );
					}
				}
			}
		}
		
		
		/**
		 * 显示收藏箱 
		 */		
		public function showStorage():void
		{
			addChild( StorageBar.instance);
		}
		
		
		
		
		
		
		
		
		public function setVisible( value:Boolean ):void
		{
			super.visible = value ;
		}
		
		private var _tempVisible:Boolean ;
		override public function set visible(value:Boolean):void
		{
			if(super.visible==value) return ;
			_tempVisible = value ;
			if( value){
				alpha = 0 ;
				TweenLite.to( this , 0.2 , {alpha:1 , onComplete: onTweenCom} );
			}else{
				alpha = 1 ;
				TweenLite.to( this , 0.2 , {alpha:0 , onComplete: onTweenCom} );
			}
		}
		
		private function onTweenCom():void{
			super.visible = _tempVisible ;
		}
		
	}
}