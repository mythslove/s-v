package local.map.item
{
	import local.vo.BitmapAnimResVO;
	
	public class Character extends MoveItem
	{
		public function Character(vo:BitmapAnimResVO)
		{
			super(vo);
			_roads = MoveItem.CHARACTER_ROADS ;
		}
		
		override public function init():void
		{
			if(Math.random()>0.5){
				_rightDirection = false ;
			}
			_roadIndex = (Math.random()*4 ) >>1 ;
			setScreenPosition( _roads[_roadIndex].x+screenX ,_roads[_roadIndex].y+screenY );
		}
		
		override protected function getNextPoint():void
		{
			if(Math.random()>0.95){ //反着走
				_rightDirection = !_rightDirection ;
			}
			super.getNextPoint() ;
		}
	}
}