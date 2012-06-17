package app.core
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class GameScene extends BaseGameScene
	{
		
		public function GameScene( picBmp:Bitmap ,  maskBmd:BitmapData)
		{
			super(picBmp,maskBmd);
		}
		
		override protected function addedToStage():void
		{
			
		}
		
	}
}