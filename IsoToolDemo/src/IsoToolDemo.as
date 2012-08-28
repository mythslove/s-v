package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	
	import local.comm.GameData;
	import local.game.GameWorld;
	
	[SWF(width="960" , height="640" , frameRate="60")]
	public class IsoToolDemo extends Sprite
	{
		public function IsoToolDemo()
		{
			super();
			
			// 支持 autoOrient
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.LOW ;
			
			GameData.app = this ;
			
			addChild( GameWorld.instance );
			
			addChild( new Stats );
		}
	}
}