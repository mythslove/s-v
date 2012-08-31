package local.map.item
{
	import flash.geom.Point;
	
	import local.util.GameUtil;
	import local.vo.BitmapAnimResVO;
	
	public class Character extends MoveItem
	{
		public function Character(vo:BitmapAnimResVO)
		{
			super(vo);
		}
		
		override protected function findNextRoad():void
		{
			var road:Road = findRandomRoad() ;
			if(road){
				_nextPoint = new Point( road.x ,road.z );
				_firstMove = true ;
				var forward:int = GameUtil.getDirection4(  road.screenX , road.screenY , screenX , screenY );
				if( Math.abs( _animObject.forward - forward)==2 ) //反方向
				{
					
				}
				else
				{
					_animObject.forward = forward;
				}
			}
		}
	}
}