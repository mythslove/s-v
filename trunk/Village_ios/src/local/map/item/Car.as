package local.map.item
{
	import local.vo.BitmapAnimResVO;
	
	public class Car extends MoveItem
	{
		public function Car(vo:BitmapAnimResVO)
		{
			super(vo);
			_roads = MoveItem.CAR_ROADS ;
		}
		
		override public function init():void
		{
			_itemLayer.scaleX = _itemLayer.scaleY =0.5;
			_speed = 1 ;
			_roadIndex = (Math.random()*4 ) >>1 ;
			setScreenPosition( _roads[_roadIndex].x+screenX ,_roads[_roadIndex].y+screenY );
		}
	}
}