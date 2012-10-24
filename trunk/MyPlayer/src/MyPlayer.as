package
{
	import com.longtailvideo.jwplayer.player.Player;
	
	import flash.display.Sprite;
	
	public class MyPlayer extends Sprite
	{
		public function MyPlayer()
		{
			var player:Player = new Player();
			addChild(player);
		}
	}
}