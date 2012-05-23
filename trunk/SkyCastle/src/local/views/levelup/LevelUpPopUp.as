package local.views.levelup
{
	import bing.components.button.BaseButton;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import local.comm.GameSetting;
	import local.model.vos.LevelVO;
	import local.model.vos.RewardsVO;
	import local.utils.PopUpManager;
	import local.views.base.BaseView;
	import local.views.rewards.RewardsPanel;
	
	public class LevelUpPopUp extends BaseView
	{
		public var container:Sprite;
		public var txtMsg:TextField;
		public var btnClose:BaseButton;
		public var btnShare:BaseButton;
		//=========================
		private var _levelupVO:LevelVO;
		
		public function LevelUpPopUp( vo:LevelVO=null )
		{
			super();
			x = GameSetting.SCREEN_WIDTH>>1;
			y = GameSetting.SCREEN_HEIGHT>>1;
			this._levelupVO = vo ;
			txtMsg.text = "Level up to level "+vo.level ;
		}
		
		override protected function added():void
		{
			var rewards:RewardsVO = _levelupVO.rewards;
			if(rewards){
				var rewardsPanel:RewardsPanel = new RewardsPanel( rewards,430 , true  );
				container.addChild( rewardsPanel);
			}
			TweenLite.from(this,0.3,{x:x-200 , ease:Back.easeOut , onComplete:inTweenOver });
		}
		
		private function inTweenOver():void
		{
			btnClose.addEventListener(MouseEvent.CLICK, onCloseHandler );
			btnShare.addEventListener(MouseEvent.CLICK, onShareHandler );
		}
		
		private function onCloseHandler( e:MouseEvent ):void
		{
			TweenLite.to(this,0.3,{x:x+200 , ease:Back.easeIn , onComplete:tweenComplete});
			mouseChildren=false;
		}
		
		private function tweenComplete():void
		{
			PopUpManager.instance.removeCurrentPopup();
		}
		
		private function onShareHandler(e:MouseEvent):void
		{
			PopUpManager.instance.removeCurrentPopup();
			//调用js，显示share
		}
		
		override protected function removed():void
		{
			_levelupVO = null ;
			btnClose.removeEventListener(MouseEvent.CLICK, onCloseHandler );
			btnShare.removeEventListener(MouseEvent.CLICK, onShareHandler );
		}
	}
}