package game.util
{
	import flash.filters.BlurFilter;
	
	import game.comm.GameSetting;

	public class GameUtil
	{
		private static  var _blurFilter:BlurFilter ;
		
		public static function get blurFilter():BlurFilter
		{
			if(!_blurFilter){
				_blurFilter = new BlurFilter();
			}
			_blurFilter.blurX = GameSetting.blur ;
			_blurFilter.blurY = GameSetting.blur ;
			return _blurFilter ;
		}
	}
}