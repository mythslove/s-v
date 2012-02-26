package local.comm
{
	import flash.display.Bitmap;
	
	import local.enum.BuildingOperation;
	import local.game.GameWorld;
	import local.utils.MouseManager;
	import local.views.icon.*;
	

	public class GameData
	{
		//********************************************************************		
		private static var _buildingCurrOperation:String = "add";
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
				case BuildingOperation.ADD:
				case BuildingOperation.NONE:
					MouseManager.instance.removeMouseIcon();
					GameWorld.instance.clearTopScene() ;
					break ;
				case BuildingOperation.MOVE:
					MouseManager.instance.addMouseIcon( new Bitmap( new MoveIconBitmapData ));
					break ;
				case BuildingOperation.STASH:
					MouseManager.instance.addMouseIcon( new Bitmap( new StashIconBitmapData ));
					break ;
				case BuildingOperation.SELL:
					MouseManager.instance.addMouseIcon( new Bitmap( new SellIconBitmapData ));
					break ;
				case BuildingOperation.ROTATE:
					MouseManager.instance.addMouseIcon( new Bitmap( new RotateIconBitmapData ));
					break ;
			}
		}
		/** 当前对建筑的操作  */
		public static function get buildingCurrOperation():String
		{
			return _buildingCurrOperation;
		}
	}
}