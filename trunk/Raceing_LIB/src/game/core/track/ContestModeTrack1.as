package game.core.track
{
	import game.vos.TrackVO;
	
	import nape.space.Space;

	/**
	 * 竞赛模式地图1 
	 * @author zzhanglin
	 */	
	public class ContestModeTrack1 extends BaseTrack
	{
		public function ContestModeTrack1( trackVO:TrackVO, space:Space, px:Number, py:Number)
		{
			super(trackVO,space, px, py);
		}
	}
}