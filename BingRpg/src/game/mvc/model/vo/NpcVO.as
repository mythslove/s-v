package game.mvc.model.vo
{
	public class NpcVO extends ItemVO
	{
		public var name:String ;
		public var type:int ;
		public var px:Number;
		public var py:Number;
		public var endTx:int =0;
		public var endTy:int = 0 ;
		public var speed:Number=0 ;
		public var direction:int ;//默认方向
	}
}