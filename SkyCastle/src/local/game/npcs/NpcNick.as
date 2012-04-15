package local.game.npcs
{
	import local.enum.ItemType;
	import local.game.elements.NPC;
	import local.model.buildings.vos.BaseCharacterVO;
	import local.model.buildings.vos.BuildingVO;

	/**
	 * npc之 nick 
	 * @author zzhanglin
	 */	
	public class NpcNick extends NPC
	{
		public function NpcNick()
		{
			var baseVO:BaseCharacterVO = new BaseCharacterVO();
			baseVO.resId="NPC_Nick";
			baseVO.alias="Nick";
			baseVO.walkable=1 ;
			baseVO.xSpan = 1 ;
			baseVO.zSpan = 1 ;
			baseVO.layer = 2 ;
			baseVO.name="Nick";
			baseVO.description = "Click to talk.";
			baseVO.type = ItemType.NPC ;
			var vo:BuildingVO = new BuildingVO();
			vo.baseVO = baseVO ;
			super(vo);
		}
	}
}