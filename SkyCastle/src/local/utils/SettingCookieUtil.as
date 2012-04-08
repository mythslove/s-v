package local.utils
{
	import bing.utils.Cookie;
	
	import flash.geom.Point;
	
	import local.comm.GameData;
	import local.model.PlayerModel;

	/**
	 * 通过SharedObject只在玩家的一些信息到本地
	 * @author zzhanglin
	 */	
	public class SettingCookieUtil
	{
		private static var _cookie:Cookie = new Cookie("skyCastle");
		
		public static function saveHeroPoint( nodeX:int , nodeZ:int ):void {
			_cookie.put( "heroNodeX" , nodeX );
			_cookie.put( "heroNodeZ" , nodeZ );
		}
		public static function getHeroPoint():Point
		{
			var point:Point = new Point();
			if(GameData.isHome && _cookie.contains( "heroNodeX") )
			{
				point.x = int(_cookie.get("heroNodeX"));
				point.y = int(_cookie.get("heroNodeZ"));
			}
			else
			{
				var level:int = GameData.isHome? PlayerModel.instance.me.level : PlayerModel.instance.friend.level ;
				if(level>25){
					point.x = GameData.heroBornPoint1.nodeX ;
					point.y = GameData.heroBornPoint1.nodeZ ;
				}else if( level>15){
					point.x = GameData.heroBornPoint2.nodeX ;
					point.y = GameData.heroBornPoint2.nodeZ ;
				}else{
					point.x = GameData.heroBornPoint3.nodeX ;
					point.y = GameData.heroBornPoint3.nodeZ ;
				}
			}
			return point ;
		}
		
		
		public static function saveMusic( value:Boolean ):void {
			_cookie.put( "music" , value );
		}
		public static function getMusic():Boolean {
			if(_cookie.contains( "music") ) return _cookie.get("music");
			return true ;
		}
		
		
		public static function saveZoom( value:Number):void {
			_cookie.put( "zoom" , value );
		}
		public static function getZoom():Number {
			if(_cookie.contains( "zoom") ) return Number(_cookie.get("zoom"));
			return 1 ;
		}
			
	}
}