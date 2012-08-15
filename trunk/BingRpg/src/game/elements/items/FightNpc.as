package game.elements.items
{
	import game.elements.items.interfaces.IFight;
	import game.mvc.model.vo.NpcVO;
	/**
	 *可战斗的npc 
	 * @author zzhanglin
	 */	
	public class FightNpc extends Npc implements IFight
	{
		public function FightNpc(npcVO:NpcVO)
		{
			super(npcVO);
		}
		
		/**
		 * 普通攻击 
		 * @param player
		 * 
		 */		
		public function simpleAttack( player:IFight ):void  
		{
			
		}
		
		/**
		 * 施法 
		 * @param magicId 法术id
		 * @param player
		 */		
		public function magic( magicId:int , player:IFight ):void 
		{
			
		}
		/**
		 *  播放死亡动作
		 */		
		public function playDeadAction():void 
		{
			
		}
		
		/**
		 * 防御 ，挡闪
		 */		
		public function defendAttack():void 
		{
			
		}
	}
}