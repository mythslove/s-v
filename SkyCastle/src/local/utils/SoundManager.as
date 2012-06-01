package local.utils
{
	public class SoundManager
	{
		private static var _instance:SoundManager ;
		public static function get instance():SoundManager
		{
			if(!_instance) _instance = new SoundManager();
			return _instance ;
		}
		//================================
		/*
		SoundBuild,SoundChopRock,SoundChopStone,SoundChopWood,SoundFinishBuilding
		SoundGreatWork,SoundHitMonster,SoundLevelup,SoundNewQuest,SoundPickupCoin
		SoundPickupEnergy,SoundPickupStone,SoundPickupWood,SoundPickupXp,SoundPopupShow,
		SoundSpecialClick,SoundBulidDown,SoundRemoveBuild,SoundClickButton
		*/
		
	}
}