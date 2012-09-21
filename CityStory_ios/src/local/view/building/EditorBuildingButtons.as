package local.view.building
{
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import local.map.GameWorld;
	import local.map.item.BaseBuilding;
	import local.view.base.BaseView;
	
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
		
		public var rotateButton:BuildingRotateButton ;
		public var sellButton:BuildingSellButton;
		public var stashButton:BuildingStashButton ;
		
		public function EditorBuildingButtons()
		{
			super();
			mouseEnabled = false ;
			stashButton = new BuildingStashButton()
			stashButton.x = -120 ;
			stashButton.y = -80 ;
			sellButton = new BuildingSellButton();
			sellButton.x = 120 ;
			sellButton.y = -80 ;
			rotateButton = new BuildingRotateButton();
			rotateButton.y = -120 ;
			addChild(sellButton);
			addChild(stashButton);
			addChild(rotateButton);
			
			addEventListener( MouseEvent.CLICK  , onClickHandler , false , 0  , true );
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			scaleX = scaleY = 0 ;
			var value:Number = 1/GameWorld.instance.scaleX ;
			TweenLite.to( this , 0.25 , { scaleX:value , scaleY:value } );
		}
		
		private function onClickHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			var building:BaseBuilding = GameWorld.instance.topScene.getChildAt(0) as BaseBuilding ;
			switch( e.target)
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