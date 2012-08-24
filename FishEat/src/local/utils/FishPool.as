package local.utils
{
	import local.game.base.BaseFish;

	/**
	 * 游戏中的鱼对象池 
	 * @author zhouzhanglin
	 */	
	public class FishPool
	{
		private static var _fishs:Array = [];
		
		public static function getFish( cls:Class ):BaseFish 
		{
			var len:int = _fishs.length ;
			for( var i:int ; i<len ; ++i )
			{
				if(_fishs[i] is cls ){
					var fish:BaseFish = _fishs.splice( i , 1 )[0] as BaseFish ;
					fish.scaleX =1 ;
					return  fish ;
				}
			}
			fish = (new cls() ) as BaseFish ;
			return fish ;
		}
		
		public static function registerFish( cls:Class ):void
		{
			var fish:BaseFish = (new cls() ) as BaseFish ;
			_fishs.push( fish );
		}
		
		public static function addFishToPool( fish:BaseFish ):void
		{
			_fishs.push( fish );
		}
	}
}