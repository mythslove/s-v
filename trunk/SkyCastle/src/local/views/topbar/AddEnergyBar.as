package local.views.topbar
{
	import bing.components.button.BaseButton;
	
	import flash.display.Sprite;
	
	import local.views.BaseView;
	import local.views.tooltip.GameToolTip;

	/**
	 * 添加energy工具栏 
	 * @author zzhanglin
	 */	
	public class AddEnergyBar extends BaseView
	{
		public var btnAddEnergy:BaseButton ;
		
		public function AddEnergyBar()
		{
			super();
		}
		
		override protected function added():void
		{
			GameToolTip.instance.register(btnAddEnergy , stage , "Click to open Energy Store." );
		}
	}
}