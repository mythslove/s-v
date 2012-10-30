package local.view.btn
{
	import local.util.TextStyle;

	public class GreenButton extends LabelButton
	{
		public function GreenButton()
		{
			super();
		}
		override public function setStyle():void
		{
			txtLabel.filters = TextStyle.greenGlowFilters ;
		}
	}
}