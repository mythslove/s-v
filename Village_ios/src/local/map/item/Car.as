package local.map.item
{
	import local.vo.BitmapAnimResVO;
	
	/**
	 * 地图上的车 
	 * @author zhouzhanglin
	 */	
	public class Car extends MoveItem
	{
		public function Car(vo:BitmapAnimResVO)
		{
			super(vo);
			_roads = MoveItem.CAR_ROADS ;
		}
		
		override public function init():void
		{
			_speed = 1.2 ;
			_roadIndex = (Math.random()*4 ) >>1 ;
			setScreenPosition( _roads[_roadIndex].x+screenX ,_roads[_roadIndex].y+screenY );
		}
	
	}
}