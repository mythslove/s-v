package local.game.npcs
{
	import local.enum.ItemType;
	import local.game.elements.NPC;
	import local.model.buildings.vos.BaseCharacterVO;
	import local.model.buildings.vos.BuildingVO;

	/**
	 * npc之 Rocky 
	 * @author zzhanglin
	 */	
	public class NpcDave extends NPC
	{
		public function NpcDave()
		{
			var baseVO:BaseCharacterVO = new BaseCharacterVO();
			baseVO.resId="NPC_Dave";
			baseVO.alias="Dave";
			baseVO.walkable=1 ;
			baseVO.xSpan = 1 ;
			baseVO.zSpan = 1 ;
			baseVO.layer = 2 ;
			baseVO.name="Dave";
			baseVO.description = "Click to talk.";
			baseVO.type = ItemType.NPC ;
			var vo:BuildingVO = new BuildingVO();
			vo.baseVO = baseVO ;
			super(vo,10000);
		}
	}
}