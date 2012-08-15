package game.mvc.view.bar
{
	import bing.utils.SystemUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	
	import game.mvc.base.GameMediator;
	
	public class ShowChatBarMediator extends GameMediator
	{
		public function get showChatBar():ShowChatBar
		{
			return view as ShowChatBar ;
		}
		public function ShowChatBarMediator(view:DisplayObjectContainer)
		{
			super(view);
		}
		
		//是否点击的是链接
		private var _isClickLink:Boolean=false;
		
		override public function onRegister():void
		{
			showChatBar.output.addEventListener( MouseEvent.CLICK , outputClickHandler );
			showChatBar.output.textfield.addEventListener( TextEvent.LINK , clickLinkTextHandler );
		}
		
		private function outputClickHandler( e:MouseEvent):void 
		{
			if(_isClickLink){
				e.stopPropagation();
			}
			_isClickLink = false ;
		}
		
		private function clickLinkTextHandler(e:TextEvent):void 
		{
			e.stopPropagation() ;
			SystemUtil.debug(e.type , e.text);   //linkx
			_isClickLink = true ;
		}
		
		override public function dispose():void
		{
			showChatBar.output.removeEventListener( MouseEvent.CLICK , outputClickHandler );
			showChatBar.output.textfield.removeEventListener( TextEvent.LINK , clickLinkTextHandler );
			super.dispose() ;
		}
	}
}