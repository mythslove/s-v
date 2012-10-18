package local.view.building
{
	import com.greensock.TweenLite;
	
	import local.map.GameWorld;
	import local.map.item.BaseBuilding;
	import local.util.EmbedManager;
	import local.view.base.BaseView;
	import local.view.base.GameButton;
	
	import starling.events.Event;
	
	/**
	 * 修改建筑时的按钮组，包括旋转，卖出，收藏 
	 * @author zhouzhanglin
	 */	
	public class EditorBuildingButtons extends BaseView
	{
		private static var _instance:EditorBuildingButtons;
		public static function get instance():EditorBuildingButtons{
			if(!_instance) _instance = new EditorBuildingButtons();
			return _instance ;
		}
		//===========================================
		
		public var rotateButton:GameButton ;
		public var sellButton:GameButton;
		public var stashButton:GameButton ;
		
		public function EditorBuildingButtons()
		{
			super();
			stashButton = new GameButton(EmbedManager.getUIImage("BuildingStashButtonUp"),
				EmbedManager.getUIImage("BuildingStashButtonDisabled"));
			stashButton.x = -120 ;
			stashButton.y = -80 ;
			sellButton = new GameButton(EmbedManager.getUIImage("BuildingSellButtonUp"),
				EmbedManager.getUIImage("BuildingSellButtonDisabled"));
			sellButton.x = 120 ;
			sellButton.y = -80 ;
			rotateButton = new GameButton(EmbedManager.getUIImage("BuildingRotateButtonUp"),
				EmbedManager.getUIImage("BuildingRotateButtonDisabled"));
			rotateButton.y = -120 ;
			addChild(sellButton);
			addChild(stashButton);
			addChild(rotateButton);
			
			sellButton.onRelease.add( onClickHandler );
			stashButton.onRelease.add( onClickHandler );
			rotateButton.onRelease.add( onClickHandler );
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			scaleX = scaleY = 0 ;
			var value:Number = 1/GameWorld.instance.scaleX ;
			TweenLite.to( this , 0.25 , { scaleX:value , scaleY:value } );
		}
		
		private function onClickHandler(btn:GameButton ):void
		{
			var building:BaseBuilding = GameWorld.instance.topScene.getChildAt(0) as BaseBuilding ;
			switch( btn )
			{
				case rotateButton:
					GameWorld.instance.buildingScene.rotateBuilding( building );
					break ;
				case sellButton:
					if(parent) parent.removeChild(this);
					building.sell() ;
					break ;
				case stashButton:
					if(parent) parent.removeChild(this);
					building.stash();
					break ;
			}
		}
	}
}