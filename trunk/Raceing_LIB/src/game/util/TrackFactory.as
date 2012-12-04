package game.util
{
	import game.core.track.BaseTrack;
	import game.core.track.*;
	import game.vos.TrackVO;
	
	import nape.space.Space;

	public class TrackFactory
	{
		public static function createTrack( trackVO:TrackVO , space:Space ):BaseTrack
		{
			var track:BaseTrack;
			switch( trackVO.id)
			{
				case 1:
					track = new ContestModeTrack1(trackVO , space );
					break ;
				case 2:
					track = new ContestModeTrack2(trackVO , space );
			}
			return track;
		}
	}
}