package local.utils
{
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	import local.game.cell.BitmapMovieClip;
	import local.views.effects.BaseMovieClipEffect;

	/**
	 * 地图上的特效管理类 
	 * @author zzhanglin
	 */	
	public class EffectManager
	{
		private static var _instance:EffectManager; 
		public static function get instance():EffectManager
		{
			if(!_instance)  _instance= new EffectManager();
			return _instance ;
		}
		//-----------------------------------------------------------
		private var _effectHash:Dictionary = new Dictionary();
		
		public function createMapEffect( mc:MovieClip ):BaseMovieClipEffect
		{
			var effect:BitmapMovieClip ;
			if(_effectHash[mc.name]){
				effect = _effectHash[mc.name] as BitmapMovieClip ;
			}else{
				effect = new BitmapMovieClip(mc);
				_effectHash[mc.name] = effect ;
			}
			return new BaseMovieClipEffect(effect.clone()) ;
		}
			
	}
}