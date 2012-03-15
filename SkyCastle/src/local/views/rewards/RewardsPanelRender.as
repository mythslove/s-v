package local.views.rewards
{
	import flash.text.TextField;
	
	import local.views.base.Image;
	
	public class RewardsPanelRender extends Image
	{
		public var txtValue:TextField;
		//=====================
		
		public function RewardsPanelRender(resId:String=null , url:String=null , value:int=0 ,  isCenter:Boolean=true, showLoading:Boolean=true)
		{
			super(resId, url, isCenter, showLoading);
			
			if(txtValue && value>0)
			{
				txtValue.text = value+"" ;
			}
		}
	}
}