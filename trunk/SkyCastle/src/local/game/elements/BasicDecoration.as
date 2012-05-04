package local.game.elements
{
	import bing.amf3.ResultEvent;
	import bing.utils.SystemUtil;
	
	import local.comm.GameData;
	import local.enum.BuildingOperation;
	import local.game.GameWorld;
	import local.model.MapGridDataModel;
	import local.model.PlayerModel;
	import local.model.buildings.vos.BuildingVO;
	import local.model.map.MapModel;
	import local.model.vos.RewardsVO;
	import local.utils.CharacterManager;
	import local.utils.CollectQueueUtil;
	import local.views.CenterViewContainer;
	import local.views.effects.MapWordEffect;
	
	/**
	 * 场景上最基本的装饰 
	 * @author zzhanglin
	 */	
	public class BasicDecoration extends Decortation
	{
		
		public function BasicDecoration(vo:BuildingVO)
		{
			super(vo);
		}
		
		override public function get isCanControl():Boolean{
			return false ;
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
						CharacterManager.instance.updateCharactersPos( this );
						MapModel.instance.addBuilding( buildingVO );
						break ;
					case BuildingOperation.ROTATE:
						buildingVO.scale = scaleX ;
						CharacterManager.instance.updateCharactersPos( this );
						break ;
					case BuildingOperation.MOVE:
						CharacterManager.instance.updateCharactersPos( this );
						break ;
					case BuildingOperation.STASH:
					case BuildingOperation.SELL :
						MapModel.instance.deleteBuilding( buildingVO );
						break ;
				}
			}
		}
		
		
		override public function execute():Boolean
		{
			super.execute();
			ro.getOperation("chop").send(nodeX,nodeZ,buildingVO.currentStep);
			return true ;
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
		
		override public function dispose():void
		{
			setWalkable( false ,MapGridDataModel.instance.basicItems );
			super.dispose();
		}
	}
}