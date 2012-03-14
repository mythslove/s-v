package local.views.bottom
{
	import bing.components.BingComponent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import local.utils.PopUpManager;
	import local.views.storage.StoragePopUp;
	
	public class StorageMenuAnim extends BingComponent
	{
		public var storageMenu:StorageMenu;
		//==============================
		
		public function StorageMenuAnim()
		{
			super();
			this.mouseEnabled = false ;
			init();
		}
		
		private function init():void
		{
			this.addFrameScript( 0,addScript,5,addScirpt5);
			function addScript():void{
				visible = false ;
				stop();
			}
			function addScirpt5():void{
				stop();
			}
		}
		
		override protected function addedToStage():void
		{
			stage.addEventListener(MouseEvent.CLICK , stageClickHandler );
			storageMenu.addEventListener(MouseEvent.CLICK , toolsMenuClickHandler );
		}
		
		private function stageClickHandler(e:MouseEvent):void
		{
			if(this.visible){
				this.gotoAndPlay("hide");
			}
		}
		
		private function toolsMenuClickHandler(e:MouseEvent):void
		{
			switch( e.target )
			{
				case storageMenu.btnCollection:
					break ;
				case storageMenu.btnStorage:
					var storagePopup:StoragePopUp = new StoragePopUp();
					PopUpManager.instance.addQueuePopUp(storagePopup,true);
					break ;
			}
			stageClickHandler(null);
		}
	}
}