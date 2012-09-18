package local.view.btn
{
	import flash.text.TextField;

	public class YellowCashButton extends LabelButton
	{
		public var txtCash:TextField ;
		//=======================
		protected var _cash:String ;
		
		public function YellowCashButton()
		{
			super();
			txtCash.defaultTextFormat = _tf ;
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
				txtCash.defaultTextFormat = _tf ;
				txtCash.text = _cash ;
			}
		}
	}
}