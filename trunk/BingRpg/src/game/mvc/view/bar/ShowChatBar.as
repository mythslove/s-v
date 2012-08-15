package game.mvc.view.bar
{
	import bing.components.button.BaseButton;
	
	import com.greensock.TweenMax;
	import com.riaidea.text.RichTextField;
	
	import fl.controls.UIScrollBar;
	
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	
	import game.mvc.view.components.BaseView;

	public class ShowChatBar extends BaseView
	{
		public var worldTabBtn:BaseButton;
		public var businessTabBtn:BaseButton;
		public var rankTabBtn:BaseButton;
		public var sysTabBtn:BaseButton;
		public var scroller:UIScrollBar ;
		//=============================
		private var _output:RichTextField;
		private var _mediator:ShowChatBarMediator;
		
		public function get output():RichTextField
		{
			return _output ;
		}
		
		public function ShowChatBar()
		{
			initView();
			_mediator = new ShowChatBarMediator(this);
		}
		
		private function initView():void
		{
			var txtFormat:TextFormat = new TextFormat("Arial,宋体", 12, 0xFFFFFF, false, false, false);
			_output = new RichTextField();
			_output.textfield.selectable=false ;
			_output.x = 5;
			_output.y = 20;
			_output.setSize(this.width - 100, this.height+10 );	
			_output.type = RichTextField.DYNAMIC;
			_output.defaultTextFormat = txtFormat;
			_output.autoScroll = true;
			_output.name = "output";
			_output.html = true ;
			TweenMax.to(_output.textfield, 0, {dropShadowFilter:{color:0, alpha:1, blurX:2, blurY:2, strength:8}});
			addChild(_output);
			
			_output.append('聊天功能还未完成');
			_output.append('<a href="event:my">链接1</a>');
			
			var style:StyleSheet = new StyleSheet();
			style.setStyle("a:link", { color: '#FFCC00', textDecoration: 'none',fontSize:'12' });
			style.setStyle("a:hover",{color:'#FF0000',fontSize:'12', textDecoration: 'underline'});
			_output.textfield.styleSheet = style ;
		}
		
		override protected function removeFromStage():void
		{
			_mediator.dispose() ;
			_mediator = null ;
			_output = null ;
		}
	}
}