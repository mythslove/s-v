package game.mvc.view.components
{
	import flash.display.Sprite;
	
	import game.mvc.base.GameContext;
	
	public class PopUpMask extends Sprite
	{
		public function PopUpMask( alpha:Number )
		{
			super();
			this.graphics.beginFill(0 , alpha );
			this.graphics.drawRect(0,0,GameContext.instance.contextView.stage.stageWidth,GameContext.instance.contextView.stage.stageHeight);
			this.graphics.endFill();
		}
	}
}