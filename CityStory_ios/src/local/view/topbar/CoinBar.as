package local.view.topbar
{
	import flash.display.Sprite;
	
	import local.util.EmbedsManager;
	import local.util.GameUtil;
	
	import pxBitmapFont.PxTextAlign;
	import pxBitmapFont.PxTextField;
	
	public class CoinBar extends Sprite
	{
		private var _label:PxTextField ;
		
		public function CoinBar()
		{
			super();
			_label = new PxTextField( EmbedsManager.instance.getBitmapFontByName("VerdanaSmall") );
			_label.useColor = false ;
			_label.fixedWidth = true ;
			_label.width = 100 ;
			_label.alignment = PxTextAlign.CENTER ;
			addChild(_label);
			_label.text = "0";
		}
		
		public function show( value:int ):void
		{
			_label.text = GameUtil.moneyFormat(value) ;
		}
	}
}