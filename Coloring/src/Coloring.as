package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.StageOrientationEvent;
	import flash.geom.Orientation3D;
	
	public class Coloring extends Sprite
	{
		public function Coloring()
		{
			super();
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 30 ;
			stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGING , onOrientaionChange);
		}
		
		private function onOrientaionChange( e:StageOrientationEvent):void
		{
			if(e.beforeOrientation==StageOrientation.UPSIDE_DOWN || e.beforeOrientation==StageOrientation.DEFAULT)
			{
				e.preventDefault() ;
			}
		}
	}
}