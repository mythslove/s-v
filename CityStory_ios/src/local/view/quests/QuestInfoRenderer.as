package local.view.quests
{
	import bing.utils.ContainerUtil;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import local.enum.QuestType;
	import local.util.GameUtil;
	import local.view.btn.BlueCashButton;
	import local.view.btn.GreenButton;
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
			btnContainer.y+=2;
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
			btnContainer.x = 0 ;
			ContainerUtil.removeChildren( btnContainer ,true );
			if(vo.questType==QuestType.OWN_BD_BY_NAME || vo.questType==QuestType.BUILD_BD_BY_NAME){
				if(vo.sonType){
					var greenBtn:GreenButton = new GreenButton();
					greenBtn.label = GameUtil.localizationString("quest.info.item.button.buy");
					btnContainer.addChild( greenBtn );
				}
			}
			if( vo.skipCash>0){
				var blueCashBtn:BlueCashButton = new BlueCashButton();
				blueCashBtn.label = GameUtil.localizationString("quest.info.item.button.skip");
				blueCashBtn.cash = vo.skipCash+"";
				blueCashBtn.x = btnContainer.numChildren*(blueCashBtn.width + 10) ;
				btnContainer.addChild( blueCashBtn );
			}
			btnContainer.x = width-btnContainer.width>>1 ;
		}
	}
}