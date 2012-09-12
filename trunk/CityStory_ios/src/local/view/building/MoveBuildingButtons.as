package local.view.building
{
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import local.comm.GameData;
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.map.item.BaseBuilding;
	import local.view.base.BaseView;
	import local.view.btn.BuildingCancelButton;
	import local.view.btn.BuildingOKButton;
	
	/**
	 * 建筑移动时，上面的确定和取消按钮 
	 * @author zhouzhanglin
	 */	
	public class MoveBuildingButtons extends BaseView
	{
		private static var _instance:MoveBuildingButtons;
		public static function get instance():MoveBuildingButtons{
			if(!_instance) _instance = new MoveBuildingButtons();
			return _instance ;
		}
		//===========================================
		
		public var cancelBtn:BuildingCancelButton ;
		public var okBtn:BuildingOKButton ;
		
		public function MoveBuildingButtons()
		{
			super();
			mouseEnabled = false ;
			cancelBtn = new BuildingCancelButton();
			cancelBtn.x = -100 ;
			cancelBtn.y = -100 ;
			okBtn = new BuildingOKButton();
			okBtn.x = 100 ;
			okBtn.y = -100 ;
			addChild(okBtn);
			addChild(cancelBtn);
			
			addEventListener( MouseEvent.CLICK  , onClickHandler , false , 0  , true );
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			scaleX = scaleY = 0 ;
			TweenLite.to( this , 0.25 , { scaleX:1 , scaleY:1 } );
		}
		
		private function onClickHandler( e:MouseEvent ):void
		{
			var building:BaseBuilding = GameWorld.instance.topScene.getChildAt(0) as BaseBuilding ;
			switch( e.target)
			{
				case okBtn:
					if( GameData.villageMode==VillageMode.BUILDING_STORAGE){
						building.storageToWorld();
					}else if( GameData.villageMode==VillageMode.BUILDING_SHOP){
						building.shopToWorld();
					}
					break ;
				case cancelBtn:
					if( GameData.villageMode==VillageMode.BUILDING_STORAGE){
						
					}
					break ;
			}
			if(parent) parent.removeChild(this);
			GameData.villageMode = VillageMode.NORMAL ;
		}
	}
}