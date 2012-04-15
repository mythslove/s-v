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
	public class NpcRocky extends NPC
	{
		public function NpcRocky()
		{
			var baseVO:BaseCharacterVO = new BaseCharacterVO();
			baseVO.resId="NPC_Rocky";
			baseVO.alias="Rocky";
			baseVO.walkable=1 ;
			baseVO.xSpan = 1 ;
			baseVO.zSpan = 1 ;
			baseVO.layer = 2 ;
			baseVO.name="Rocky";
			baseVO.description = "Click to talk.";
			baseVO.type = ItemType.NPC ;
			var vo:BuildingVO = new BuildingVO();
			vo.baseVO = baseVO ;
			super(vo);
		}
	}
}