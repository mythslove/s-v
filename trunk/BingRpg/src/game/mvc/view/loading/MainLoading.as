package game.mvc.view.loading{
	
	import com.greensock.TweenLite;
	
	import flash.utils.setTimeout;
	
	/**
	 * 主程加载进度 
	 * @author zhouzhanglin
	 */	
	public class MainLoading extends BaseMainLoading
	{
		private var _sumStep:int ;
		private var _maskBarStartX:Number ;
		private var _maskBarEndX:Number ;
		private var _maskBarEndDistance:Number ;
		private var _pro:Number ;
		private var _mediator:MainLoadingMeditor ;
		
		public function MainLoading( sumStep:int )
		{
			super();
			_mediator = new MainLoadingMeditor( this );
			
			this.mouseChildren = false ;
			_sumStep = sumStep ;
			init();
		}
		
		private function init():void
		{
			_maskBarStartX = this.maskBar.x ;
			_maskBarEndX = this.loadingBar.x ;
			_maskBarEndDistance = _maskBarEndX - _maskBarStartX ;
			txtMC.txtLoading.text = "0%";
		}
		
		public function update( step:int , progress:Number ):void
		{
			if(step<=0) return ;
			_pro =(step-1+progress)/_sumStep ;
			
			TweenLite.to( maskBar , 0.5 , {x: _pro*_maskBarEndDistance +_maskBarStartX , onUpdate:tweenUpdate , onComplete:tweenUpdate } );
		}
		
		private function tweenUpdate():void
		{
			txtMC.x = maskBar.x + maskBar.width ;
			txtMC.txtLoading.text = Math.ceil( (maskBar.x-_maskBarStartX)/_maskBarEndDistance*100)+"%" ;
		}
		
		public function dispose():void
		{
			setTimeout( fadeOut, 1000 );
			_mediator.dispose() ;
			_mediator = null ;
		}
		
		private function fadeOut():void
		{
			TweenLite.to(this, 0.5 , {alpha:0 , onComplete:tweenCom });
		}
		
		private function tweenCom():void
		{
			if(this.parent){
				this.parent.removeChild( this );
			}
		}
		
	}
}