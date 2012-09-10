package local.view.shop
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class ShopTabButton extends MovieClip
	{
		public var txtLabel:TextField ;
		//=====================
		
		private var _label:String ;
		
		public function ShopTabButton( label:String = null )
		{
			super();
			mouseChildren = false ;
			stop();
			if(label){
				name = label ;
				this._label = label ;
				this.txtLabel.text = label ;
			}
		}
		
		public function get label():String
		{
			return _label;
		}

		public function set label(value:String):void
		{
			_label = value;
			if(label){
				name = label ;
				this._label = label ;
				this.txtLabel.text = label ;
			}
		}

		override public function gotoAndStop(frame:Object, scene:String=null):void{
			super.gotoAndStop(frame,scene);
			if( txtLabel.text!=_label){
				txtLabel.text = _label ;
			}
		}
	}
}