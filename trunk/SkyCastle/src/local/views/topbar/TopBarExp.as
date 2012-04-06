package local.views.topbar
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import local.views.BaseView;
	import local.views.tooltip.GameToolTip;
	
	public class TopBarExp extends BaseView
	{
		public var txtLevel:TextField;
		public var txtValue:TextField ;
		public var bar:Sprite;
		//====================
		private var _inited:Boolean ;
		
		public function TopBarExp()
		{
			super();
		}
		
		override protected function added():void{
			GameToolTip.instance.register(txtValue , stage , "EXPERIENCE: Get experience by buying thinds and completing tasks." );
		}
		
		public function update(obj:Object):void
		{
			txtValue.text = obj[0]+"/"+obj[2];
			txtLevel.text = obj[3] ;
			if(_inited){
				TweenLite.to( bar , 0.4 , {scaleX:  obj[0]/obj[2]});
			}else{
				bar.scaleX = obj[0]/obj[2] ;
				_inited = true ;
			}
			if(bar.scaleX>1){
				bar.scaleX = 1;
			}
			GameToolTip.instance.register(txtLevel , stage , "LEVEL: "+obj[3] );
		}
	}
}