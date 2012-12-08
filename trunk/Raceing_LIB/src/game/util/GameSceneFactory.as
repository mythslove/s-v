package game.util
{
	import game.comm.GameMode;
	import game.core.scene.BaseContestGameScene;
	import game.core.scene.CatchGameScene;
	import game.core.scene.ContestGameScene;
	import game.core.scene.RotateGameScene;
	import game.vos.PlayerCarVO;
	import game.vos.TrackVO;

	public class GameSceneFactory
	{
		/**
		 *  创建游戏场景
		 * @param gameMode GameMode常量
		 * @param trackVO
		 * @param playerCarVO
		 * @param competitorIndex
		 * @return 
		 * 
		 */		
		public static function createGameSceneFactory(trackVO:TrackVO ,  playerCarVO:PlayerCarVO , competitorIndex:int = 0 ):BaseContestGameScene
		{
			var scene:BaseContestGameScene;
			switch( trackVO.gameMode)
			{
				case GameMode.CATCH:
					scene = new CatchGameScene(trackVO,playerCarVO,competitorIndex);
					break ;
				case GameMode.CONTEST:
					scene = new ContestGameScene(trackVO,playerCarVO,competitorIndex);
					break ;
				case GameMode.ROTATE:
					scene = new RotateGameScene(trackVO,playerCarVO,competitorIndex);
					break ;
			}
			return scene;
		}
	}
}