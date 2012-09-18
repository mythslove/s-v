package local.view.btn
{
	import flash.text.TextField;

	public class YellowCashButton extends LabelButton
	{
		public var txtValue:TextField ;
		//=======================
		protected var _value:String ;
		
		public function YellowCashButton()
		{
			super();
			txtValue.defaultTextFormat = _tf ;
		}
		
		public function get value():String
		{
			return _value;
		}
		
		public function set value(v:String):void
		{
			_value = v;
			if(_value){
				this.txtValue.text = _value ;
			}
		}
		
		override public function gotoAndStop(frame:Object, scene:String=null):void{
			super.gotoAndStop(frame,scene);
			if( txtValue.text!=_value){
				txtValue.defaultTextFormat = _tf ;
				txtValue.text = _value ;
			}
		}
	}
}