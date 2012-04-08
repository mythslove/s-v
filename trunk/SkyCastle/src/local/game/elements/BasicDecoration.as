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
			var level:int = PlayerModel.instance.me.level ;
			if(parent==GameWorld.instance.buildingScene2)
			{
				if(level<15)
				{
					var effect:MapWordEffect = new MapWordEffect("Need Level 15!");
					GameWorld.instance.addEffect(effect,screenX,screenY);
					return ;
				}
			}
			else if(parent==GameWorld.instance.buildingScene1)
			{
				if(level<25)
				{
					effect = new MapWordEffect("Need Level 25!");
					GameWorld.instance.addEffect(effect,screenX,screenY);
					return ;
				}
			}
			//减能量
			if(PlayerModel.instance.me.energy<1){
				effect = new MapWordEffect("You don't have enough Energy!");
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
//			ro.getOperation("chop").send(buildingVO.id , buildingVO.currentStep);
		}
		
		override protected function onResultHandler(e:ResultEvent):void
		{
			SystemUtil.debug(e.service , e.method , e.result);
			switch(e.method)
			{
				case "chop": 
					
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
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}