package local.map.item
{
	import local.vo.BitmapAnimResVO;
	
	/**
	 * 地图上走路的人 
	 * @author zhouzhanglin
	 */	
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
		
		
		/** 移动到一个点 */
//		override protected function moveToPoint():void
//		{
//			GameData.commPoint.x = screenX ;
//			GameData.commPoint.y = screenY ;
//			var distance:Number = Point.distance( _nextPoint , GameData.commPoint ) ;
//			if(distance < _speed){
//				_nextPoint = null; 
//			} else {
//				var moveNum:Number = distance/_speed ;
//				this.setScreenPosition( screenX+(_nextPoint.x - screenX)/moveNum , screenY+(_nextPoint.y - screenY)/moveNum );
//			}
//			sort();
//		}
		
		override protected function getNextPoint():void
		{
			if(Math.random()>0.95){ //反着走
				_rightDirection = !_rightDirection ;
			}
			super.getNextPoint() ;
		}
	}
}