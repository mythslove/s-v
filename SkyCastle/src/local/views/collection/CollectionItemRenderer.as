package local.views.collection
{
	import bing.components.button.BaseButton;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import local.views.BaseView;
	/**
	 * 一组收集显示 
	 * @author zzhanglin
	 */	
	public class CollectionItemRenderer extends BaseView
	{
		public var levelBar:CollectionLevelBar ;
		public var txtTitle:TextField;
//		txtName1:TextField,	img1:Sprite ,	txCount1:TextField , icon1:Spirte , txtReward1:TextField
		public var btnTurnIn:BaseButton;
		
		public function CollectionItemRenderer()
		{
			super();
		}
	}
}