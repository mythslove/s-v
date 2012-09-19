package local.view.storage
{
	import flash.display.MovieClip;
	
	public class StorageMenuButton extends MovieClip
	{
		public function StorageMenuButton( name:String )
		{
			super();
			mouseChildren = false ;
			stop();
			
			this.name = name ;
		}
	}
}