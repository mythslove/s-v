package local.view.btn
{
	import local.util.TextStyle;

	public class GreenCashButton extends YellowCashButton
	{
		public function GreenCashButton()
		{
			super();
		}
		override public function setStyle():void
		{
			txtLabel.filters = TextStyle.greenGlowFilters ;
			txtCash.filters = TextStyle.greenGlowFilters ;
		}
	}
}