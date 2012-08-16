package local.comm
{
	import flash.display.Sprite;
	
	import local.enum.BuildingOperation;
	import local.enum.MouseStatus;
	import local.game.GameWorld;
	import local.game.elements.HeroBornPoint;
	import local.model.vos.ConfigBaseVO;
	import local.utils.MouseManager;
	import local.views.LeftBar;
	import local.views.icon.*;
	

	public class GameData
	{
		
		public static var APP:Sprite; //主灰
		
		
		//********************************************************************		
		private static var _buildingCurrOperation:String = BuildingOperation.NONE ;
		/**
		 *  设置当前对鼠标的操作，并更改鼠标跟随icon
		 * @param value BuildingCurrentOperation中的常量
		 */
		public static function set buildingCurrOperation(value:String):void
		{
			if(_buildingCurrOperation==BuildingOperation.MOVE){ 
				//如果原来是move,则将原来的建筑还原
				GameWorld.instance.moveFail();
			}
			_buildingCurrOperation = value;
			switch(value){
				case BuildingOperation.PLACE_STASH:
				case BuildingOperation.BUY:
				case BuildingOperation.NONE:
					MouseManager.instance.mouseStatus = MouseStatus.NONE ;
					GameWorld.instance.clearTopScene(true) ;
					break ;
				case BuildingOperation.MOVE:
					MouseManager.instance.mouseStatus = MouseStatus.MOVE_BUILDING ;
					break ;
				case BuildingOperation.STASH:
					MouseManager.instance.mouseStatus = MouseStatus.STASH_BUILDING ;
					break ;
				case BuildingOperation.SELL:
					MouseManager.instance.mouseStatus = MouseStatus.SELL_BUILDING ;
					break ;
				case BuildingOperation.ROTATE:
					MouseManager.instance.mouseStatus = MouseStatus.ROTATE_BUILDING ;
					break ;
			}
		}
		/** 当前对建筑的操作  */
		public static function get buildingCurrOperation():String
		{
			return _buildingCurrOperation;
		}
		
		/** 是否是管理员 */
		public static var isAdmin:Boolean ;
		
		/** 系统配置 */
		public static var config:ConfigBaseVO ;
		
		/** 当前的地图 */
		public static var currentMapId:String = "MAP_01";
		
		/** 是否在自己的村庄*/
		public static var _isHome:Boolean ;
		public static function get isHome():Boolean
		{
			return _isHome ;
		}
		public static function set isHome( value:Boolean):void
		{
			_isHome = value ;
			if(_isHome)
			{
				LeftBar.instance.visible = true ;
			}
			else
			{
				LeftBar.instance.visible = false ;
			}
		}
		
		/** 当前用户的uid*/
		public static var me_uid:String ;
		
		//三个传送点
		public static var heroBornPoint1:HeroBornPoint ;
		public static var heroBornPoint2:HeroBornPoint ;
		public static var heroBornPoint3:HeroBornPoint ;
		
		
		//后两个地图
		public static const LV2:int = 15 ;
		public static const LV3:int = 30 ;
	}
}