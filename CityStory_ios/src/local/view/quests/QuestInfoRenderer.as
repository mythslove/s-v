package local.view.quests
{
	import bing.utils.ContainerUtil;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import local.util.GameUtil;
	import local.vo.QuestTaskVO;
	
	public class QuestInfoRenderer extends Sprite
	{
		public var imgContainer:Sprite;
		public var btnContainer:Sprite;
		public var txtInfo:TextField;
		public var txtTitle:TextField ;
		public var txtProgress:TextField;
		//==============================
		
		public var taskVO:QuestTaskVO ;
		
		public function QuestInfoRenderer()
		{
			super();
			imgContainer.mouseChildren = imgContainer.mouseEnabled = false ;
			txtInfo.mouseEnabled=txtTitle.mouseEnabled=txtProgress.mouseEnabled=false;
		}
		
		public function show( vo:QuestTaskVO ):void
		{
			txtInfo.text = vo.info ;
			GameUtil.boldTextField( txtTitle , vo.title );
			txtTitle.height = txtTitle.textHeight+4 ;
			GameUtil.boldTextField( txtProgress , vo.current +"/" + vo.sum );
			ContainerUtil.removeChildren( imgContainer );
			ContainerUtil.removeChildren( btnContainer );
		}
	}
}