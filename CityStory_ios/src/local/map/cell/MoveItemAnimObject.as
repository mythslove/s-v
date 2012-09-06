package local.map.cell
{
	import bing.animation.ActionVO;
	import bing.animation.AnimationBitmap;
	
	import local.vo.BitmapAnimResVO;
	
	/**
	 * 可移动的对象 ，人和车的动画组件
	 * @author zhouzhanglin
	 */	
	public class MoveItemAnimObject extends BaseAnimObject
	{
		public var forward:int =1 ;
		private var _actionNum:int ;
		
		public function MoveItemAnimObject(vo:BitmapAnimResVO , actionNum:int )
		{
			_actionNum = actionNum ;
			super(vo);
		}
		
		
		override protected function init():void
		{
			x = _vo.offsetX ;
			y = _vo.offsetY ;
			var actions:Vector.<ActionVO> = Vector.<ActionVO>([
					new ActionVO("walk1", _actionNum ),
					new ActionVO("walk2", _actionNum )
			]);
			_anim = new AnimationBitmap(  _vo.bmds , actions, _vo.rate ) ;
		}
		
		protected function playAction():void
		{
			if(parent){
				if(forward>2){
					var temp:int = forward==3?2:1 ;
					if(parent.scaleX>0){
						parent.scaleX = -1;
					}
					_anim.playAction("walk"+temp);
				} else {
					if(parent.scaleX<0){
						parent.scaleX = 1;
					}
					_anim.playAction("walk"+forward);
				}
			}
		}
		
		
		override public function update():void
		{
			if(_anim){ 
				playAction();
				if(bitmapData != _anim.animationBmd){
					bitmapData =  _anim.animationBmd ;
				}
			}
		}
		
	}
}