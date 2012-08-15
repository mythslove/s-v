package game.elements.cell
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import game.mvc.model.AniBaseModel;
	import game.mvc.model.vo.AniBaseVO;
	import game.mvc.model.vo.MagicVO;
	
	public class EffectComponent extends Sprite
	{
		private var _magicVO:MagicVO ; //特效VO
		private var _magicDic:Dictionary ; //特效资源集合
		private var _effectBmp:Bitmap ; //特效的图片
		private var _cycleTime:int ; //循环动画的次数
		private var _callFun:Function=null ; //回调函数
		private var _actionName:String ; //动作名称 
		private var _aniBaseVO:AniBaseVO ; //基本动画VO
		private var _timeoutId:int ; //timeout的id
		private var _duration:int ; //动画完成后还需要的持续时间
		private var _resLoaded:Boolean=false ; //素材资源是否下载完成
		public var isOver:Boolean = false ; //是否应该被删除
		public var _aniComponent:AniComponent ;
		
		/**
		 * 特效 
		 * @param magicVO 特效VO
		 * @param callFun 播放次数完成后的回调函数
		 * @param cycleTime 播放次数，如果小于1，则循环播放
		 * @param duration 动作播放完成后还需要的持续时间
		 */		
		public function EffectComponent( magicVO:MagicVO , callFun:Function = null , cycleTime:int = 1 , duration:int = 0 )
		{
			super();
			this._magicVO = magicVO ;
			this._cycleTime = cycleTime ;
			this._callFun = callFun ;
			this._duration = duration ;
			init();
		}
		
		private function init():void 
		{
			_aniBaseVO= AniBaseModel.instance.getAniBaseByName( _magicVO.magicAniName) ;
			_actionName =_aniBaseVO.actions[0].actionName ;
			
			_effectBmp = new Bitmap();
			_effectBmp.x = _magicVO.fromX-_aniBaseVO.offsetX;
			_effectBmp.y = _magicVO.fromY-_aniBaseVO.offsetY;
			addChild(_effectBmp);
			
			_aniComponent = new AniComponent(_aniBaseVO); 
			if(_cycleTime>0){
				_aniComponent.setAniCycle( tempCallFun , _cycleTime );
			}
			_resLoaded = ( _aniComponent.aniBitmap!=null );
		}
		
		private function tempCallFun():void 
		{
			if(_duration>0 && _aniComponent.aniBitmap ){
				_aniComponent.aniBitmap.stopAni();
				_timeoutId = setTimeout(executeCallFun ,  _duration );
			}else{
				executeCallFun();
			}
		}
		
		private function executeCallFun():void 
		{
			if(_callFun!=null){
				_callFun( this );
			}
		}
		
		public function update():void 
		{
			if(_resLoaded && _aniComponent && _aniComponent.aniBitmap)
			{
				_aniComponent.aniBitmap.playAction( _actionName );
				_effectBmp.bitmapData = _aniComponent.aniBitmap.animationBmd ;
				_effectBmp.x = (_magicVO.fromX-_magicVO.toX)*0.02-_aniBaseVO.offsetX;
				_effectBmp.y = (_magicVO.fromY-_magicVO.toY)*0.02-_aniBaseVO.offsetY;
			}
		}
		
		public function dispose():void 
		{
			if(_magicDic){
				for each(var aniCom:AniComponent in _magicDic){
					if(aniCom){
						aniCom.dispose();
					}
				}
			}
			if(_aniComponent){
				_aniComponent.dispose();
			}
			if(_timeoutId>0){
				clearTimeout(_timeoutId);
			}
			_effectBmp = null ;
			_magicDic = null ;
			_callFun = null ;
			_aniComponent = null ;
			_magicVO = null ;
			_aniBaseVO = null ;
		}
	}
}