package local.view.base
{
	import feathers.controls.Button;
	
	public class GameButton extends Button
	{
		public function GameButton()
		{
			super();
			this.onPress.add( dark );
			this.onRelease.add( light );
		}
		
		private function dark():void
		{
			
		}
		
		private function light():void
		{
			
		}
	}
}