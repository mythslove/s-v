package local.map.item
{
	import bing.starling.component.FrameSprite;
	
	import local.vo.ItemVO;
	
	public class Character extends BaseItem
	{
		public static const ACTION_STAND:String ="stand";
		public static const ACTION_WALK:String = "walk";
		public static const ACTION_SIT:String = "sit";
		public static const ACTION_EAT:String = "eat";
		//=========================================
		private var _frameSprite:FrameSprite ;
		private var _action:String ;
		
		public function Character(itemVO:ItemVO)
		{
			super(itemVO);
		}
		
		public function play( action:String ):void
		{
			
			this._action = action ;
		}
	}
}