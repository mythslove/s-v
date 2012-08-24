package local.scenes.component
{
	
	import local.utils.AssetsManager;
	import local.utils.SoundManager;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class SoundButton extends Sprite
	{
		public var closeButton:Button ;
		public var openButton:Button ;
		
		public function SoundButton()
		{
			super();
			closeButton = new Button( AssetsManager.createTextureAtlas("uiTexture").getTexture("SoundButton_000") , "" ); 
			openButton = new Button( AssetsManager.createTextureAtlas("uiTexture").getTexture("SoundButton_001") , "" ); 
			
			addChild(closeButton);
			closeButton.visible=false;
			addChild(openButton);
			
			openButton.addEventListener( Event.TRIGGERED , onClickHandler );
			closeButton.addEventListener( Event.TRIGGERED , onClickHandler );
		}
		
		private function onClickHandler( e:Event):void
		{
			if( closeButton.visible )
			{
				closeButton.visible = false;
				openButton.visible = true ;
				SoundManager.playSoundBg();
			}
			else
			{
				closeButton.visible = true;
				openButton.visible = false ;
				SoundManager.stopSound();
			}
		}
	}
}