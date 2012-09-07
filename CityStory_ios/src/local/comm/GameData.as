package  local.comm
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import local.enum.VillageMode;
	import local.map.GameWorld;

	public class GameData
	{
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
		
		
		private static var _villageMode:String = VillageMode.NORMAL  ;
		/**村庄的状态，VillageMode常量 */		
		public static function get villageMode():String {
			return _villageMode ;
		}
		public static function set villageMode( value:String):void
		{
			_villageMode = value ;
			var world:GameWorld = GameWorld.instance ;
			switch(value){
				case VillageMode.NORMAL :
					world.buildingScene.mouseChildren = true ;
					world.buildingScene.alpha=1;
					world.runUpdate = true ;
					world.roadScene.mouseChildren = false ;
					world.topScene.visible = false ;
					world.iconScene.visible = true ;
					break ;
				case VillageMode.EDIT :
					world.buildingScene.mouseChildren = true ;
					world.runUpdate = false ;
					world.roadScene.mouseChildren = true ;
					world.topScene.visible = true ;
					world.iconScene.visible = false ;
					break ;
				case VillageMode.ADD_BUILDING :
					world.buildingScene.mouseChildren = false ;
					world.runUpdate = false ;
					world.roadScene.mouseChildren = false ;
					world.topScene.visible = true ;
					world.iconScene.visible = false ;
					break ;
				case VillageMode.EXPAND :
					world.buildingScene.mouseChildren = false ;
					world.buildingScene.alpha=0.6;
					world.runUpdate = false ;
					world.roadScene.mouseChildren = false ;
					world.topScene.visible = true ;
					world.iconScene.visible = false ;
					break ;
			}
		}
	}
}