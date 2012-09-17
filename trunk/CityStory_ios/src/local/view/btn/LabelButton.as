package local.view.btn
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import local.view.control.Button;
	
	/**
	 * 里面有一个txtLabel文本框，并且文本框中字体加粗 
	 * @author zhouzhanglin
	 */	
	public class LabelButton extends Button
	{
		public var txtLabel:TextField ;
		//=====================
		
		private var _label:String ;
		private var _tf:TextFormat ;
		
		public function LabelButton()
		{
			super();
			_tf = txtLabel.defaultTextFormat ;
			_tf.bold = true ;
			txtLabel.defaultTextFormat = _tf ;
		}
		
		public function get label():String
		{
			return _label;
		}
		
		public function set label(value:String):void
		{
			_label = value;
			if(_label){
				this.txtLabel.text = _label ;
			}
		}
		
		override public function gotoAndStop(frame:Object, scene:String=null):void{
			super.gotoAndStop(frame,scene);
			if( txtLabel.text!=_label){
				txtLabel.defaultTextFormat = _tf ;
				txtLabel.text = _label ;
			}
		}
	}
}