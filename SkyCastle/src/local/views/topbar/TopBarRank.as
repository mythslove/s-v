package local.views.topbar
{
	import flash.text.TextField;
	
	import local.views.BaseView;
	import local.views.tooltip.GameToolTip;

	/**
	 * 繁荣度 
	 * @author zhouzhanglin
	 */	
	public class TopBarRank extends BaseView
	{
		public var txtValue:TextField;
		//=====================
		
		public function TopBarRank()
		{
			super();
			mouseChildren=false;
		}
		
		override protected function added():void
		{
			GameToolTip.instance.register(this , stage , "RANK: rank can increase your sky castle's prosperity.");
		}
		
		public function update(obj:Object):void
		{
			txtValue.text = String(obj) ;
		}
	}
}