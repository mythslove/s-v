package local.view.btn
{
	import local.util.TextStyle;

	public class BlueCashButton extends YellowCashButton
	{
		public function BlueCashButton()
		{
			super();
		}
		
		override public function setStyle():void
		{
			txtLabel.filters = TextStyle.blueGlowFilters ;
			txtCash.filters = TextStyle.blueGlowFilters ;
		}
	}
}