package local.util
{
	

	public class GameUtil
	{
		/**
		 * 方向位置 
		 * @param p1
		 * @param p2
		 * @return 
		 */		
		public static function getDirection4( x1:Number , y1:Number , x2:Number , y2:Number  ):int{
			var nx:Number=x1-x2 ;
			var ny:Number=y1-y2 ;
			var r:Number=Math.sqrt(nx*nx+ny*ny);
			var cos:Number=nx/r;
			var angle:int=int(Math.floor(Math.acos(cos)*180/Math.PI));
			if(ny<0){
				angle=360-angle;
			}
			if(angle>270 ){
				return 1 ;
			}else if(angle>180)	{
				return 4;	
			}else if(angle>90){
				return 3 ;
			}else {
				return 2 ;
			}
			
		}
	}
}