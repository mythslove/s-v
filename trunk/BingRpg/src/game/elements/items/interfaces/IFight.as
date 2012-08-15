package game.elements.items.interfaces
{
	public interface IFight
	{
		/**
		 * 普通攻击 
		 * @param player
		 * 
		 */		
		function simpleAttack( player:IFight ):void  ;
			
		/**
		 * 施法 
		 * @param magicId 法术id
		 * @param player
		 */		
		function magic( magicId:int , player:IFight ):void ;
		
		/**
		 *  播放死亡动作
		 */		
		function playDeadAction():void ; 
		
		/**
		 * 防御 ，挡闪
		 */		
		function defendAttack():void ;
		
		
	}
}