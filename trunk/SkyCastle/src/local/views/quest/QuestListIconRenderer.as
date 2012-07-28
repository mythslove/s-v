package local.views.quest
{
	import bing.components.BingComponent;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import local.model.vos.QuestVO;
	import local.views.base.Image;
	import local.views.tooltip.GameToolTip;
	
	/**
	 * 任务图片列表renderer 
	 * @author zzhanglin
	 */	
	public class QuestListIconRenderer extends BingComponent
	{
		public var txtName:TextField ;
		public var container:Sprite ;
		//=======================
		
		public var questVO :QuestVO  ;
		
		public function QuestListIconRenderer( vo:QuestVO )
		{
			super();
			mouseChildren = false; 
			questVO = vo ;
		}
		
		override protected function addedToStage():void
		{
			GameToolTip.instance.register( this , stage, questVO.title );
			txtName.text = questVO.title ;
			var thumb:Image = new Image( "quest"+questVO.icon , "res/quest/"+questVO.icon );
			container.addChild(thumb);
		}
		
		public function setSeleted( value:Boolean ):void
		{
			if(value){
				gotoAndStop(2);
			}else{
				gotoAndStop(1);
			}
		}
		
		override protected function removedFromStage():void
		{
			questVO = null ;
		}
	}
}