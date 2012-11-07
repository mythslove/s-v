package local.view.btns
{
	import com.greensock.TweenLite;
	
	import local.map.GameWorld;
	import local.map.item.BaseItem;
	import local.util.EmbedManager;
	import local.view.base.BaseView;
	import local.view.base.GameButton;
	
	import starling.events.Event;
	
	public class EditItemButtons extends BaseView
	{
		private static var _instance:EditItemButtons;
		public static function get instance():EditItemButtons{
			if(!_instance) _instance = new EditItemButtons();
			return _instance ;
		}
		//===========================================
		
		public var rotateButton:GameButton ;
		public var sellButton:GameButton;
		public var stashButton:GameButton ;
		
		public function EditItemButtons()
		{
			super();
			stashButton = new GameButton(EmbedManager.getUIImage("StashButton") );
			stashButton.x = -120 ;
			stashButton.y = -80 ;
			
			sellButton = new GameButton(EmbedManager.getUIImage("SellButton") );
			sellButton.x = 120 ;
			sellButton.y = -80 ;
			
//			rotateButton = new GameButton(EmbedManager.getUIImage("ItemRotateButtonUp"),
//				EmbedManager.getUIImage("ItemRotateButtonDisabled"));
//			rotateButton.y = -120 ;
			
			addChild(sellButton);
			addChild(stashButton);
//			addChild(rotateButton);
			
			sellButton.addEventListener(Event.TRIGGERED , onClickHandler );
			stashButton.addEventListener(Event.TRIGGERED , onClickHandler );
//			rotateButton.addEventListener(Event.TRIGGERED , onClickHandler );
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			scaleX = scaleY = 0 ;
			var value:Number = 1/GameWorld.instance.scaleX ;
			TweenLite.to( this , 0.2 , { scaleX:value , scaleY:value } );
		}
		
		private function onClickHandler(btn:GameButton ):void
		{
			var item:BaseItem = GameWorld.instance.topScene.getChildAt(0) as BaseItem ;
			switch( btn )
			{
//				case rotateButton:
//					GameWorld.instance.itemScene.rotateItem( item );
//					break ;
				case sellButton:
					if(parent) parent.removeChild(this);
					item.sell() ;
					break ;
				case stashButton:
					if(parent) parent.removeChild(this);
					item.stash();
					break ;
			}
		}
		
		/**
		 * 防止被清除 
		 */		
		override public function dispose():void{}
	}
}