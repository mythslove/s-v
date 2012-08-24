package local.level
{
	public class Level0 extends BaseLevel
	{
		public function Level0()
		{
			level = 0 ; //从0开始
			name = "The beginning..." ;
			fish1Count = 3 ;
			fish2Count = 2 ;
			fish3Count = 2 ;
			fish4Count = 2 ;
			fish5Count = 1 ;
			starCount = 0 ;
			requireFish = [40,80] ;
			requireScore = 120 ;
			
			
			fish1Speed = 1.8 ;
			fish2Speed = 1.8  ;
			fish3Speed = 1.7 ;
			fish4Speed = 3 ;
			fish5Speed = 3  ;
		}
	}
}