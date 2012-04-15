package local.game.npcs
{
	import local.enum.ItemType;
	import local.game.elements.NPC;
	import local.model.buildings.vos.BaseCharacterVO;
	import local.model.buildings.vos.BuildingVO;

	/**
	 * npc之 Tony 
	 * @author zzhanglin
	 */	
	public class NpcTony extends NPC
	{
		public function NpcTony()
		{
			var baseVO:BaseCharacterVO = new BaseCharacterVO();
			baseVO.resId="NPC_Tony";
			baseVO.alias="Tony";
			baseVO.walkable=1 ;
			baseVO.xSpan = 1 ;
			baseVO.zSpan = 1 ;
			baseVO.layer = 2 ;
			baseVO.name="Tony";
			baseVO.description = "Click to talk.";
			baseVO.type = ItemType.NPC ;
			var vo:BuildingVO = new BuildingVO();
			vo.baseVO = baseVO ;
			super(vo);
		}
	}
}