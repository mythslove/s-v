package local.views.topbar
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import local.views.BaseView;
	import local.views.tooltip.GameToolTip;
	
	public class TopBarEnergy extends BaseView
	{
		public var txtValue:TextField ;
		public var bar:Sprite;
		//====================
		private var _inited:Boolean ;
		
		public function TopBarEnergy()
		{
			super();
		}
		
		override protected function added():void{
			GameToolTip.instance.register(txtValue , stage , "ENERGY:Used to complete tasks." );
		}
		
		public function update(obj:Object):void
		{
			txtValue.text = obj[0]+"/"+obj[1];
			if(_inited){
				TweenLite.to( bar , 0.4 , {scaleX:  obj[0]/obj[1]});
			}else{
				bar.scaleX = obj[0]/obj[1] ;
				_inited = true ;
			}
			if(bar.scaleX>1){
				bar.scaleX = 1 ;
			}
		}
	}
}