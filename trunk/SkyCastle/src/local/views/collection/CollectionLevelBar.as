package local.views.collection
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import local.model.CollectionModel;
	import local.model.vos.CollectionVO;

	/**
	 * 收集的等级显示条 
	 * @author zzhanglin
	 */	
	public class CollectionLevelBar extends Sprite
	{
		public var txtLevel:TextField ;
		public var proBar:Sprite ;
		//======================
		
		public function CollectionLevelBar()
		{
			super();
		}
		
		public function showLevel( lv:int = 0 , scale:Number=0 ):void
		{
			txtLevel.text = lv+"";
			proBar.scaleX = scale ;
		}
	}
}