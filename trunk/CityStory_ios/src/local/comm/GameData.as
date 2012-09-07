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
			switch(value){
				case VillageMode.NORMAL :
					GameWorld.instance.buildingScene.mouseChildren = true ;
					GameWorld.instance.roadScene.mouseChildren = false ;
					GameWorld.instance.topScene.visible = false ;
					GameWorld.instance.iconScene.visible = true ;
					break ;
				case VillageMode.EDIT :
					GameWorld.instance.buildingScene.mouseChildren = true ;
					GameWorld.instance.roadScene.mouseChildren = true ;
					GameWorld.instance.topScene.visible = true ;
					GameWorld.instance.iconScene.visible = false ;
					break ;
				case VillageMode.ADD_BUILDING :
					GameWorld.instance.buildingScene.mouseChildren = false ;
					GameWorld.instance.roadScene.mouseChildren = false ;
					GameWorld.instance.topScene.visible = true ;
					GameWorld.instance.iconScene.visible = false ;
					break ;
				case VillageMode.EXPAND :
					GameWorld.instance.buildingScene.mouseChildren = false ;
					GameWorld.instance.roadScene.mouseChildren = false ;
					GameWorld.instance.topScene.visible = true ;
					GameWorld.instance.iconScene.visible = false ;
					break ;
			}
		}
	}
}