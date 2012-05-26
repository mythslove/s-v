package local.views.rewards
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import local.views.base.Image;

	/**
	 * 奖励的显示项 
	 * @author zzhanglin
	 */	
	public class RewardsPanelRender extends Sprite
	{
		public var txtValue:TextField;
		public var txtCount:TextField;
		//=====================
		
		public function RewardsPanelRender(resId:String=null , url:String=null  , value:String = null , count:String=null)
		{
			super(); 
			mouseChildren=mouseEnabled = false ;
			var img:Image = new Image(resId , url ,true,true);
			addChildAt( img , 0 );
			if(value) txtValue.text = value ;
			if(count) txtCount.text = count ;
		}
	}
}