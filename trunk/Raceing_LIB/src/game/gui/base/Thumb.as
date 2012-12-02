package game.gui.base
{
	import starling.display.Sprite;
	
	public class Thumb extends Sprite
	{
		private var _url:String ;
		private var _showLoading:Boolean ;
		
		public function Thumb( url:String , showLoading:Boolean = false )
		{
			super();
			this._url = url ;
			this._showLoading = showLoading ;
		}
	}
}