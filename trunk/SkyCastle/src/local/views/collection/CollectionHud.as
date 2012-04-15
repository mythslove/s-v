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
		public var txtProgress:TextField;
		public var btnTurnIn:BaseButton;
		public var img0:Sprite,img1:Sprite,img2:Sprite,img3:Sprite,img4:Sprite;
		//==========================
		
		public function CollectionHud()
		{
			super();
		}
	}
}