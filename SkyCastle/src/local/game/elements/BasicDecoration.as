package local.game.elements
{
	import local.game.GameWorld;
	import local.model.VillageModel;
	import local.model.buildings.vos.BaseRockVO;
	import local.model.buildings.vos.BuildingVO;
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
			if(VillageModel.instance.me.energy<1){
				var effect:MapWordEffect = new MapWordEffect("You don't have enough Energy!");
				GameWorld.instance.addEffect(effect,screenX,screenY);
			}else{
				super.onClick();
				this.showStep( buildingVO.step-1,baseBuildingVO["earnStep"]);
			}
		}
	}
}