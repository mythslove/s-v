package local.views.topbar
{
	import flash.text.TextField;
	
	import local.views.base.BaseView;
	import local.views.tooltip.GameToolTip;
	
	public class TopBarVillage extends BaseView
	{
		public var txtName:TextField; //村庄名字
		public var txtRank:TextField; //繁荣度
		//=====================
		
		public function TopBarVillage() {
			super();
			txtName.mouseEnabled = false ;
			mouseEnabled = false ;
		}
		
		override protected function added():void {
			GameToolTip.instance.register(txtRank , stage , "RANK: rank can increase your sky castle's prosperity.");
		}
		
		public function updateName( value:String ):void
		{
			txtName.text = value ;
		}
		public function updateRank( value:int ):void
		{
			txtRank.text = value+"" ;
		}
		
	}
}