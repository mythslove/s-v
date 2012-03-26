package local.game.elements
{
	import bing.amf3.RemoteObject;
	import bing.amf3.ResultEvent;
	
	import local.comm.GameRemote;
	import local.enum.BuildingOperation;
	import local.game.GameWorld;
	import local.model.VillageModel;
	import local.model.buildings.vos.BaseRockVO;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.CharacterManager;
	import local.views.effects.MapWordEffect;
	
	public class BasicDecoration extends Decortation
	{
		private var _mapRo:GameRemote ;
		public function get mapRo():GameRemote{
			if(!_mapRo){
				_mapRo = new GameRemote("mapservice");
			}
			return _mapRo;
		}
		
		public function BasicDecoration(vo:BuildingVO)
		{
			super(vo);
		}
		
		override public function onClick():void
		{
			//减能量
			if(VillageModel.instance.me.energy<1){
				var effect:MapWordEffect = new MapWordEffect("You don't have enough Energy!");
				GameWorld.instance.addEffect(effect,screenX,screenY);
			}else{
				super.onClick();
				this.showStep( buildingVO.step-1,baseBuildingVO["earnStep"]);
			}
		}
		
		override public function sendOperation(operation:String):void
		{
			switch( operation )
			{
				case BuildingOperation.ADD:
					CharacterManager.instance.updateCharacters( this );
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
					break ;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_mapRo){
				_mapRo.dispose();
				_mapRo = null ;
			}
		}
	}
}