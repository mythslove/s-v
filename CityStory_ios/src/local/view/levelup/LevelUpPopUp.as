package local.view.levelup
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.events.Event;
	
	import local.comm.GameSetting;
	import local.map.GameWorld;
	import local.model.ShopModel;
	import local.util.PopUpManager;
	import local.view.base.BaseView;
	import local.vo.BaseBuildingVO;
	import local.vo.LevelVO;
	
	public class LevelUpPopUp extends BaseView
	{
		private var _levelVO:LevelVO ;
		
		public function LevelUpPopUp( levelVO:LevelVO )
		{
			super();
			this._levelVO = levelVO ;
			init();
		}
		
		private function init():void
		{
			var baseBuildings:Vector.<BaseBuildingVO> = ShopModel.instance.getUnlockBuildings( _levelVO.level );
			
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			GameWorld.instance.stopRun();
			x = GameSetting.SCREEN_WIDTH>>1 ;
			y = GameSetting.SCREEN_HEIGHT>>1 ;
			TweenLite.from( this , 0.3 , { x:x-200 , ease: Back.easeOut  });
		}
		
		
		
		
		private function close():void{
			GameWorld.instance.visible=true;
			mouseChildren=false;
			TweenLite.to( this , 0.3 , { x:x+200 , ease: Back.easeIn , onComplete:onTweenCom});
		}
		private function onTweenCom():void{
			PopUpManager.instance.removeCurrentPopup() ;
		}
		override protected function removedFromStageHandler(e:Event):void{
			super.removedFromStageHandler(e);
			GameWorld.instance.run();
			GameWorld.instance.visible=true;
			_levelVO = null ;
			dispose();
		}
	}
}