package local.game.elements
{
	import bing.amf3.ResultEvent;
	import bing.utils.SystemUtil;
	
	import local.comm.GameData;
	import local.enum.BuildingOperation;
	import local.game.GameWorld;
	import local.model.PlayerModel;
	import local.model.buildings.vos.BuildingVO;
	import local.model.map.MapModel;
	import local.model.vos.RewardsVO;
	import local.utils.CharacterManager;
	import local.utils.CollectQueueUtil;
	import local.views.CenterViewContainer;
	import local.views.effects.MapWordEffect;
	
	public class BasicDecoration extends Decortation
	{
		
		public function BasicDecoration(vo:BuildingVO)
		{
			super(vo);
		}
		
		override public function onClick():void
		{
			//减能量
			if(PlayerModel.instance.me.energy<1){
				var effect:MapWordEffect = new MapWordEffect("You don't have enough Energy!");
				GameWorld.instance.addEffect(effect,screenX,screenY);
			}else{
				super.onClick();
				this.showStep( buildingVO.currentStep,baseBuildingVO["step"]);
			}
		}
		
		override public function sendOperation(operation:String):void
		{
			if(GameData.isAdmin)
			{
				switch( operation )
				{
					case BuildingOperation.BUY:
						CharacterManager.instance.updateCharacters( this );
						MapModel.instance.addBuilding( buildingVO );
						break ;
					case BuildingOperation.ROTATE:
						buildingVO.scale = scaleX ;
						CharacterManager.instance.updateCharacters( this );
						break ;
					case BuildingOperation.MOVE:
						CharacterManager.instance.updateCharacters( this );
						break ;
					case BuildingOperation.STASH:
					case BuildingOperation.SELL :
						MapModel.instance.deleteBuilding( buildingVO );
						break ;
				}
			}
		}
		
		
		override public function execute():void
		{
			super.execute();
			_currentRewards = null ;
			_executeBack = false ;
			ro.getOperation("chop").send(nodeX,nodeZ,buildingVO.currentStep);
		}
		
		override protected function onResultHandler(e:ResultEvent):void
		{
			SystemUtil.debug("返回数据：",e.service+"."+e.method , e.result);
			switch(e.method)
			{
				case "chop": 
					_executeBack = true ;
					_currentRewards = e.result as RewardsVO ;
					this.showPickup();
					break ;
			}
		}
		
		/**
		 * 调用execute时减一个能量
		 * @return 
		 */		
		protected function executeReduceEnergy():Boolean
		{
			//减能量
			var effect:MapWordEffect ;
			if(PlayerModel.instance.me.energy>=1){
				effect = new MapWordEffect("Energy -1");
				PlayerModel.instance.me.energy-- ;
				CenterViewContainer.instance.topBar.updateTopBar();
				GameWorld.instance.addEffect(effect,screenX,screenY);
			}else{
				CollectQueueUtil.instance.clear(true);
				effect = new MapWordEffect("You don't have enough Energy!");
				GameWorld.instance.addEffect(effect,screenX,screenY);
				//能量不够，弹出购买能量的窗口
				return  false;
			}
			return true;
		}
		
	}
}