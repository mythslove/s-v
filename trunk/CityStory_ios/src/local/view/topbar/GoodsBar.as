package local.view.topbar
{
	import flash.display.Sprite;
	
	import local.util.EmbedsManager;
	import local.util.GameUtil;
	
	import pxBitmapFont.PxTextAlign;
	import pxBitmapFont.PxTextField;
	
	public class GoodsBar extends Sprite
	{
		private var _label:PxTextField ;
		
		public function GoodsBar()
		{
			super();
			_label = new PxTextField( EmbedsManager.instance.getBitmapFontByName("VerdanaSmall") );
			_label.useColor = false ;
			_label.fixedWidth = true ;
			_label.width = 200 ;
			_label.alignment = PxTextAlign.CENTER ;
			_label.x = 5;
			_label.y = 12;
			addChild(_label);
		}
		
		public function show( value:int ):void
		{
			_label.text = GameUtil.moneyFormat(value) ;
		}
	}
}