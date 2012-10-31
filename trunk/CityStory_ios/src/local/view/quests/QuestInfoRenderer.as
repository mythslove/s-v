package local.view.quests
{
	import bing.utils.ContainerUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import local.enum.QuestType;
	import local.model.ShopModel;
	import local.util.GameUtil;
	import local.util.PopUpManager;
	import local.util.TextStyle;
	import local.view.btn.BlueCashButton;
	import local.view.btn.GreenButton;
	import local.view.control.DynamicBitmapTF;
	import local.view.shop.ShopPopUp;
	import local.vo.BaseBuildingVO;
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
			addEventListener(MouseEvent.CLICK , onClickHandler );
		}
		
		public function show( vo:QuestTaskVO ):void
		{
			this.taskVO = vo ;
			txtInfo.text = vo.info ;
			GameUtil.boldTextField( txtTitle , vo.title );
			txtTitle.height = txtTitle.textHeight+4 ;
			GameUtil.boldTextField( txtProgress , vo.current +"/" + vo.sum );
			ContainerUtil.removeChildren( imgContainer );
			btnContainer.x = 0 ;
			ContainerUtil.removeChildren( btnContainer ,true );
			if(!vo.isComplete){
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
			}
			else
			{
				var tf:DynamicBitmapTF = new DynamicBitmapTF("Trebuchet MS",
					200,NaN,"Completed!","center",2,30,true,0xffffff,false,false,TextStyle.blackGlowfilters);
				btnContainer.addChild(tf);
			}
			btnContainer.x = width-btnContainer.width>>1 ;
		}
		
		private function onClickHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			if(e.target is BlueCashButton)
			{
				
			}
			else if(e.target is GreenButton)
			{
				var baseVO:BaseBuildingVO = ShopModel.instance.allBuildingHash[ taskVO.sonType ] as BaseBuildingVO;
				if(baseVO){
					PopUpManager.instance.addQueuePopUp( ShopPopUp.instance );
					ShopPopUp.instance.scrollToBuilding( baseVO.type , baseVO.name );
					PopUpManager.instance.removeCurrentPopup();
				}
			}
		}
	}
}