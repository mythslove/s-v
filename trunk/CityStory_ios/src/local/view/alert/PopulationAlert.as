package local.view.alert
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import local.comm.GameSetting;
	import local.enum.BuildingType;
	import local.map.GameWorld;
	import local.model.PlayerModel;
	import local.util.GameUtil;
	import local.util.PopUpManager;
	import local.view.base.BaseView;
	import local.view.btn.GreenLengthButton;
	import local.view.btn.PopUpCloseButton;
	import local.view.shop.ShopOverViewPopUp;
	import local.view.shop.ShopPopUp;
	
	public class PopulationAlert extends BaseView
	{
		public var btnClose:PopUpCloseButton ;
		public var btnPop:GreenLengthButton;
		public var btnCap:GreenLengthButton;
		public var txtPopTitle:TextField ;
		public var txtCapTitle:TextField ;
		public var txtPopInfo:TextField ;
		public var txtCapInfo:TextField ;
		//===========================
		
		public function PopulationAlert()
		{
			super();
			txtPopInfo.mouseEnabled = txtPopTitle.mouseEnabled = txtCapInfo.mouseEnabled= txtCapTitle.mouseEnabled = false ;
			mouseEnabled = false ;
			init();
		}
		
		private function init():void
		{
			btnPop.txtLabel.text = GameUtil.localizationString("popalert.popinfo.button") ;
			btnCap.txtLabel.text = GameUtil.localizationString("popalert.capinfo.button") ;
			GameUtil.boldTextField( txtPopInfo , GameUtil.localizationString("popalert.popinfo") );
			GameUtil.boldTextField( txtCapInfo , GameUtil.localizationString("popalert.capinfo") );
			GameUtil.boldTextField( txtPopTitle , GameUtil.localizationString("pop")+": "+PlayerModel.instance.getCurrentPop() );
			GameUtil.boldTextField( txtCapTitle , GameUtil.localizationString("cap")+": "+ PlayerModel.instance.me.cap);
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			GameWorld.instance.stopRun();
			x = GameSetting.SCREEN_WIDTH>>1 ;
			y = GameSetting.SCREEN_HEIGHT>>1 ;
			TweenLite.from( this , 0.3 , { x:x-200 , ease: Back.easeOut });
			addEventListener(MouseEvent.CLICK , onClickHandler );
		}
		
		private function onClickHandler( e:MouseEvent ):void
		{
			e.stopPropagation() ;
			switch(e.target)
			{
				case btnClose:
					close();
					break ;
				case btnPop:
					PopUpManager.instance.addQueuePopUp( ShopPopUp.instance );
					ShopPopUp.instance.show(BuildingType.HOME);
					PopUpManager.instance.removeCurrentPopup() ;
					break ;
				case btnCap:
					PopUpManager.instance.addQueuePopUp( ShopOverViewPopUp.instance );
					PopUpManager.instance.removeCurrentPopup() ;
					break ;
			}
		}
		
		
		private function close():void{
			mouseChildren=false;
			TweenLite.to( this , 0.3 , { x:x+200 , ease: Back.easeIn , onComplete:onTweenCom});
		}
		private function onTweenCom():void{
			PopUpManager.instance.removeCurrentPopup() ;
		}
		override protected function removedFromStageHandler(e:Event):void{
			GameWorld.instance.run();
			removeEventListener(MouseEvent.CLICK , onClickHandler );
			dispose();
		}
	}
}