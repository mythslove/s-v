package local.view.btn
{
	import local.util.TextStyle;
	import local.view.control.BitmapTextField;

	public class YellowCashButton extends LabelButton
	{
		public var txtCash:BitmapTextField ;
		//=======================
		protected var _cash:String ;
		
		public function YellowCashButton()
		{
			super();
		}
		
		override public function setStyle():void
		{
			txtLabel.filters = TextStyle.yellowGlowFilters ;
			txtCash.filters = TextStyle.yellowGlowFilters ;
		}
		
		public function get cash():String
		{
			return _cash;
		}
		
		public function set cash(value:String):void
		{
			_cash = value;
			if(_cash){
				txtCash.text = _cash ;
			}
		}
		
		override public function gotoAndStop(frame:Object, scene:String=null):void{
			super.gotoAndStop(frame,scene);
			if( txtCash.text!=_cash){
				txtCash.text = _cash ;
			}
		}
		
		override public function dispose():void{
			super.dispose();
			txtCash.dispose();
			txtCash = null ;
		}
	}
}