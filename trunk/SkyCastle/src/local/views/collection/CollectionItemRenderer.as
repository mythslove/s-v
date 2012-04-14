package local.views.collection
{
	import bing.components.button.BaseButton;
	
	import flash.text.TextField;
	
	import local.model.vos.CollectionVO;
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
		//===========================
		private var _currCollection:CollectionVO ;
		
		public function CollectionItemRenderer( collectionVO:CollectionVO= null )
		{
			super();
			this._currCollection = collectionVO ;
		}
		
		override protected function added():void
		{
				
		}
		
		override protected function removed():void
		{
			_currCollection = null ;
		}
	}
}