package local.utils
{
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	import local.views.effects.BitmapMovieClip;
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
		
		/**
		 * 创建一次性的特效。只播放一次就消失
		 * @param mc
	 	 * @param loopTime 循环次数，0为无限
		 * @return 
		 */		
		public function createMapEffectByMC( mc:MovieClip , loopTime:int = 1  ):BaseMovieClipEffect
		{
			return new BaseMovieClipEffect(createBmpAnimByMC(mc),loopTime) ;
		}
		
		/**
		 * 创建位图动画
		 * @param mc
		 * @return 
		 */		
		public function createBmpAnimByMC( mc:MovieClip ):BitmapMovieClip
		{
			var effect:BitmapMovieClip ;
			if(_effectHash.hasOwnProperty(mc.toString())){
				effect = _effectHash[mc.toString()] as BitmapMovieClip ;
				return effect.clone();
			}else{
				effect = new BitmapMovieClip(mc);
				_effectHash[mc.toString()] = effect ;
				return effect ;
			}
		}
	}
}