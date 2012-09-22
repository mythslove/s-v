package local.view.topbar
{
	import flash.display.Sprite;
	
	import local.util.EmbedsManager;
	
	import pxBitmapFont.PxTextAlign;
	import pxBitmapFont.PxTextField;
	
	public class EnergyBar extends Sprite
	{
		private var _label:PxTextField ;
		
		public function EnergyBar()
		{
			super();
			_label = new PxTextField( EmbedsManager.instance.getBitmapFontByName("VerdanaSmall") );
			_label.useColor = false ;
			_label.fixedWidth = true ;
			_label.width = 200 ;
			_label.alignment = PxTextAlign.CENTER ;
			_label.y = 15;
			addChild(_label);
		}
		
		public function show( value:int , max:int ):void
		{
			_label.text = value +"/"+ max ;
		}
	}
}