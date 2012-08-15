package game.mvc.model.vo
{
	public class ItemVO
	{
		public var faceId:int ;
		public var totalDirection:Array ;
		public var mouseEnable:Boolean=true;
		
		public var standAniName:String ;
		public var runAniName:String ;
		public var simpleAttackAniName:String ;
		public var defendAttackAniName:String ; //防御动作名称
		public var deadAniName:String ; //死亡动作名称
		public var magicAttackAniName:String ; //法术动作名称
	}
}