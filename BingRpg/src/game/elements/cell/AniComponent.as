package game.elements.cell
{
	import bing.animation.AnimationBitmap;
	import bing.animation.AnimationEvent;
	import bing.res.ResLoadedEvent;
	import bing.res.ResVO;
	import bing.utils.SystemUtil;
	
	import flash.display.BitmapData;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import game.mvc.model.vo.AniBaseVO;
	import game.utils.GameResourePool;

	public class AniComponent
	{
		public var aniBitmap:AnimationBitmap ;
		public var aniBaseVO:AniBaseVO ;
		private var _callFun:Function=null ;
		private var _timeId:int ;
		
		public function AniComponent( aniBaseVO:AniBaseVO )
		{
			this.aniBaseVO = aniBaseVO ;
			GameResourePool.instance.addEventListener( aniBaseVO.name , resLoadedHandler );
			var resVO:ResVO = new ResVO();
			resVO.name = aniBaseVO.name ;
			resVO.url = aniBaseVO.url;
			resVO.frames = aniBaseVO.totalFrame;
			resVO.num = aniBaseVO.totalFrame;
			resVO.resType = aniBaseVO.resType;
			resVO.reflectType = aniBaseVO.reflectType;
			resVO.priority = aniBaseVO.priority ;
			GameResourePool.instance.loadRes( resVO );
		}
		
		private function resLoadedHandler(e:ResLoadedEvent):void
		{
			e.stopPropagation() ;
			GameResourePool.instance.removeEventListener( aniBaseVO.name , resLoadedHandler );
			if(e.resVO.resObject==null)
			{
				SystemUtil.debug(e.resVO.name+"没有图片资源");
			}else{
				aniBitmap = new AnimationBitmap( e.resVO.resObject as Vector.<BitmapData> , aniBaseVO.actions , aniBaseVO.frameRate );
				aniBitmap.addEventListener(AnimationEvent.ANIMATION_COMPLETE , animationCompleteHandler );
			}
		}
		
		/**
		 * 重置 
		 */		
		public function reset():void
		{
			if(aniBitmap){
				aniBitmap.start(0);
			}
			if(_timeId>0) clearTimeout(_timeId);
			_timeId = 0 ;
			_callFun = null ;
		}
		
		/**
		 * 设置动作的循环次数，完成后回调 
		 * @param callFun 回调函数
		 * @param cycle 循环次数，默认为1
		 */		
		public function setAniCycle(  callFun:Function , cycle:int=1 ):void
		{
			reset();
			this._callFun = callFun ;
			if(aniBitmap){
				aniBitmap.cycleTime = cycle ;
			}else{
				_timeId = setTimeout( _callFun , 1000 );
			}
		}
		
		/**
		 * 一个动作完成事件 
		 * @param e
		 */		
		private function animationCompleteHandler(e:AnimationEvent):void 
		{
			e.stopPropagation() ;
			if(_callFun!=null){
				_callFun();
			}
			_callFun = null ;
		}
		
		public function dispose():void
		{
			GameResourePool.instance.removeEventListener( aniBaseVO.name , resLoadedHandler );
			if( aniBitmap ){
				aniBitmap.removeEventListener(AnimationEvent.ANIMATION_COMPLETE , animationCompleteHandler );
				aniBitmap = null ;
			}
			aniBaseVO = null ;
			_callFun = null ;
			if(_timeId>0) clearTimeout(_timeId);
		}
	}
}