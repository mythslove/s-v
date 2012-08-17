package views.components
{
	import comm.GameSetting;
	
	import mx.core.UIComponent;
	
	public class GameGrid extends UIComponent
	{
		public function GameGrid()
		{
			super();
			var color:uint = 0x549733 ;
			this.graphics.beginFill(color,1);
			this.graphics.moveTo( 0 , 0 );
			this.graphics.lineTo( GameSetting.SIZE , GameSetting.SIZE/2 );
			this.graphics.lineTo( 0 , GameSetting.SIZE );
			this.graphics.lineTo( -GameSetting.SIZE , GameSetting.SIZE/2 );
			this.graphics.lineTo( 0 , 0);
			this.graphics.endFill() ;
		}
		
		public function update(type:int ):void
		{
			if(type<1 || type>4) {
				type =1 ;
			}
			scaleX = scaleY = type;
		}
	}
}