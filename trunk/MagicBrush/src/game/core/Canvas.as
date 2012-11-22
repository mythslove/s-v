package game.core
{
	import flash.display.Sprite;
	
	public class Canvas extends Sprite
	{
		private var _wid:Number ;
		private var _het:Number ;
		
		public function Canvas( wid:Number , het:Number )
		{
			super();
			this._wid = wid ;
			this._het = het ;
			init();
		}
		
		private function init():void
		{
			this.graphics.beginFill( 0x282828);
			this.graphics.drawRect(0,0,_wid,_het);
			this.graphics.endFill();
		}
	}
}