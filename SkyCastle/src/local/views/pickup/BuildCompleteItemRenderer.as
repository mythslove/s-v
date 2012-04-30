package local.views.pickup
{
	import bing.components.BingComponent;
	import bing.components.button.BaseButton;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * 建造完成时材料窗口的renderer 
	 * 有两帧，skip和default
	 * @author zzhanglin
	 */	
	public class BuildCompleteItemRenderer extends BingComponent
	{
		public var txtName:TextField ;
		public var txtCount:TextField ;
		public var btnSkip:BaseButton;
		public var container:Sprite;
		//=============================
		
		public function BuildCompleteItemRenderer()
		{
			super();
		}
		
		override protected function addedToStage():void
		{
			
		}
		
		private function onSkipHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
		}
		
		override protected function removedFromStage():void
		{
			if(btnSkip && btnSkip.hasEventListener(MouseEvent.CLICK) ){
				btnSkip.removeEventListener(MouseEvent.CLICK , onSkipHandler );
			}
		}
				
	}
}