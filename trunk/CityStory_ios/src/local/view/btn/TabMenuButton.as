package local.view.btn
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class TabMenuButton extends MovieClip
	{
		public var txtLabel:TextField ;
		//=====================
		
		private var _label:String ;
		private var _tf:TextFormat ;
		
		public function TabMenuButton( label:String = null , name:String = null )
		{
			super();
			mouseChildren = false ;
			stop();
			
			_tf = txtLabel.defaultTextFormat ;
			_tf.bold = true ;
			txtLabel.defaultTextFormat = _tf ;
			
			if(label){
				if(name){
					this.name = name ;
				}else{
					this.name = label ;
				}
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