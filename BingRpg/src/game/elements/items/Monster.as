package game.elements.items
{
	import game.elements.items.interfaces.IFight;

	/**
	 * 怪 
	 * @author zzhanglin
	 */	
	public class Monster extends Player implements IFight
	{
		public function Monster(id:int, faceId:int, name:String)
		{
			super(id, faceId, name);
		}
	}
}