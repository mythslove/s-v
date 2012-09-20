package  local.comm
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.view.CenterViewLayer;

	public class GameData
	{
		
		/**
		 * 语言包 
		 */		
		public static var lang:Object ;
		
		/**
		 * 公用的date
		 */		
		public static var commDate:Date = new Date();
		
		/**
		 * 公用 的point 
		 */		
		public static var commPoint:Point = new Point();
		
		/**
		 * 公用 的Vector3D 
		 */	
		public static var commVec:Vector3D = new Vector3D();
		
		private static var _villageMode:String   ;
		/**村庄的状态，VillageMode常量 */		
		public static function get villageMode():String {
			return _villageMode ;
		}
		public static function set villageMode( value:String):void
		{
			if(_villageMode==value) return ;
			_villageMode = value ;
			CenterViewLayer.instance.changeStatus( value );
			var world:GameWorld = GameWorld.instance ;
			switch(value){
				case VillageMode.NORMAL :
					world.buildingScene.mouseChildren = true ;
					world.buildingScene.alpha=1;
					world.buildingScene.addMoveItems();
					world.runUpdate = true ;
					world.roadScene.mouseChildren = false ;
					world.topScene.visible = false ;
					world.topScene.clearAndDisposeChild();
					world.iconScene.visible = true ;
					world.visibleExpandSigns( true ) ;
					world.buildingScene.checkRoadsAndIcons();
					world.sortIcons();
					break ;
				case VillageMode.EDIT :
					world.buildingScene.mouseChildren = true ;
					world.buildingScene.removeMoveItems();
					world.runUpdate = false ;
					world.roadScene.mouseChildren = true ;
					world.topScene.clearAndDisposeChild();
					world.topScene.visible = true ;
					world.iconScene.visible = false ;
					break ;
				case VillageMode.BUILDING_STORAGE :
				case VillageMode.BUILDING_SHOP :
					world.buildingScene.mouseChildren = false ;
					world.buildingScene.removeMoveItems();
					world.runUpdate = false ;
					world.roadScene.mouseChildren = false ;
					world.topScene.visible = true ;
					world.iconScene.visible = false ;
					break ;
				case VillageMode.EXPAND :
					world.buildingScene.mouseChildren = false ;
					world.buildingScene.removeMoveItems();
					world.buildingScene.alpha=0.5;
					world.runUpdate = false ;
					world.roadScene.mouseChildren = false ;
					world.topScene.visible = true ;
					world.iconScene.visible = false ;
					world.visibleExpandSigns( false ) ;
					world.showExpandState();
					break ;
			}
			if(world.currentSelected){
				world.currentSelected.flash(false);
				world.currentSelected = null ;
			}
		}
	}
}