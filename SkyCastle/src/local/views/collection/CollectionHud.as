package local.views.collection
{
	import bing.components.button.BaseButton;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import local.views.BaseView;

	/**
	 *  主界面弹出的收集器界面
	 * @author zzhanglin
	 */	
	public class CollectionHud extends BaseView
	{
		public var txtTitle:TextField;
		public var txtLevel:TextField;
		public var txtProgress:Sprite;
		public var btnTurnIn:BaseButton;
//		img1:Sprite
		//==========================
		
		public function CollectionHud()
		{
			super();
		}
	}
}