package game.elements.items
{
	import flash.geom.Point;
	
	import game.elements.items.interfaces.IFight;
	import game.events.HeroEvent;
	/**
	 * 英雄 
	 * @author zzhanglin
	 */
	public class Hero extends Player implements IFight
	{
		public function Hero( id:int , faceId:int, name:String)
		{
			super(id , faceId, name);
		}
		
		/**
		 * 移动到一个点 
		 * @param point
		 * @return 是否到达该点
		 */		
		override public function moveToPoint( point:Point):Boolean 
		{
			var b:Boolean = super.moveToPoint(point) ;
			if( b ){
				if(roadIndex==roads.length){
					this.dispatchContextEvent( new HeroEvent(HeroEvent.ARRIVED_DESTINATION) ) ;
				}
			}
			return b ;
		}
	}
}