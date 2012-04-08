package local.game.elements
{
	import bing.amf3.ResultEvent;
	
	import local.comm.GameData;
	import local.enum.BuildingOperation;
	import local.game.GameWorld;
	import local.model.PlayerModel;
	import local.model.buildings.vos.BuildingVO;
	import local.model.map.MapModel;
	import local.utils.CharacterManager;
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
		
		
		override protected function onResultHandler(e:ResultEvent):void
		{
			switch(e.method)
			{
				case "chop": 
					
					break ;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}