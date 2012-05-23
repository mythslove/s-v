package local.views.topbar
{
	import bing.components.button.BaseButton;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import local.views.base.BaseView;
	import local.views.tooltip.GameToolTip;

	/**
	 * 添加energy工具栏 
	 * @author zzhanglin
	 */	
	public class AddEnergyBar extends BaseView
	{
		public var btnAddEnergy:BaseButton ;
		//============================
		
		public function AddEnergyBar()
		{
			super();
		}
		
		override protected function added():void
		{
			GameToolTip.instance.register(btnAddEnergy , stage , "Click to open Energy Store." );
			btnAddEnergy.addEventListener(MouseEvent.CLICK , onAddEnergyHandler );
		}
		
		private function onAddEnergyHandler(e:MouseEvent):void
		{
			e.stopPropagation();
			
		}
	}
}