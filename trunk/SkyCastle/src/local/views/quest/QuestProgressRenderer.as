package local.views.quest
{
	import bing.components.BingComponent;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import local.model.vos.QuestItemVO;
	import local.views.base.Image;

	/**
	 * 任务的进度Render
	 * @author zzhanglin
	 */	
	public class QuestProgressRenderer extends BingComponent
	{
		public var img:Sprite; //图片容器
		public var txtDes:TextField; //描述
		public var txtCount:TextField; //进度
		//================================
		public var itemVO:QuestItemVO ;
		
		public function QuestProgressRenderer( itemVO:QuestItemVO)
		{
			super();
			stop();
			mouseEnabled = mouseChildren = false ;
			this.itemVO = itemVO ;
		}
		
		override protected function addedToStage():void
		{
			txtDes.text = itemVO.title ;
			txtCount.text = itemVO.current+"/"+itemVO.sum ;
			var thumb:Image = new Image( "questItem"+itemVO.icon , "res/quest/"+itemVO.icon) ;
			img.addChild( thumb );
		}
		
		override protected function removedFromStage():void
		{
			stop();
			itemVO = null ;
		}
	}
}