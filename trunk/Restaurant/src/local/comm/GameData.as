package local.comm
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.view.CenterViewLayer;

	public class GameData
	{
		public static var commDate:Date=new Date();
		
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
					world.roomScene.touchable = true ;
					world.roomScene.alpha=1;
					world.runUpdate = true ;
					world.floorScene.touchable = false ;
					world.topScene.visible = false ;
					world.topScene.clearAndDisposeChild();
					world.iconScene.visible = true ;
//					world.sortIcons();
					break ;
				case VillageMode.EDIT :
					world.roomScene.touchable = true ;
					world.runUpdate = false ;
					world.floorScene.touchable = true ;
					world.topScene.clearAndDisposeChild();
					world.topScene.visible = true ;
					world.iconScene.visible = false ;
					break ;
				case VillageMode.BUILDING_STORAGE :
				case VillageMode.BUILDING_SHOP :
					world.roomScene.touchable = false ;
					world.runUpdate = false ;
					world.floorScene.touchable = false ;
					world.topScene.visible = true ;
					world.iconScene.visible = false ;
					break ;
				case VillageMode.VISIT:
					world.floorScene.touchable = false ;
					world.topScene.visible = false ;
					world.iconScene.visible = false ;
					world.runUpdate = true ;
					break ;
			}
		}
		
		/** 当前是否有地在扩 */
		public static var hasExpanding:Boolean = false ;
	}
}