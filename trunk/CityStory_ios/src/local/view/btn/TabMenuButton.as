package local.view.btn
{
	import flash.display.MovieClip;
	
	import local.util.TextStyle;
	import local.view.control.BitmapTextField;
	
	public class TabMenuButton extends MovieClip
	{
		public var txtLabel:BitmapTextField ;
		//=====================
		
		
		private var _label:String ;
		
		public function TabMenuButton( label:String = null , name:String = null )
		{
			super();
			mouseChildren = false ;
			stop();
			
			TextStyle.setTabMenuFormat( txtLabel );
			
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
				txtLabel.text = _label ;
			}
		}
	}
}