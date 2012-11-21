package game.util
{
	import flash.filters.BlurFilter;
	
	import game.comm.GameSetting;

	public class GameUtil
	{
		private static  var _blurFilter:BlurFilter ;
		private static var _blurs:Array ;
		
		public static function get blurFilter():Array
		{
			if(!_blurFilter){
				_blurFilter = new BlurFilter();
				_blurs = [_blurFilter];
			}
			_blurFilter.blurX = GameSetting.blur ;
			_blurFilter.blurY = GameSetting.blur ;
			return _blurs ;
		}
	}
}