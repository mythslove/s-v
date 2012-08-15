package game.utils
{
	import flash.geom.Point;

	/**
	 * 方向工具类 
	 * @author zhouzhanglin
	 */	
	public class DirectionUtil
	{
		/**
		 * 方向位置 
		 * @param p1
		 * @param p2
		 * @return 
		 * 
		 */		
		public static function getDirection8( p1:Point , p2:Point ):int{
			var nx:Number=p1.x-p2.x ;
			var ny:Number=p1.y-p2.y ;
			var r:Number=Math.sqrt(nx*nx+ny*ny);
			var cos:Number=nx/r;
			var angle:int=int(Math.floor(Math.acos(cos)*180/Math.PI));
			
			if(ny<0){
				angle=360-angle;
			}
			
			if(angle>337 || angle<23){
				return 7; // west
			} else if(angle>292){
				return 6; // southwest
			} else if(angle>247){
				return 5; // south
			} else if(angle>202){
				return 4;  // southeast
			} else if(angle>157){
				return 3; //east 
			} else if(angle>112){
				return 2; //northeast
			} else if(angle>67){
				return 1; //north
			} else{
				return 8; //northwest
			}
			
		}
		
		/**
		 * 方向位置 
		 * @param p1
		 * @param p2
		 * @return 
		 * 
		 */		
		public static function getDirection4( p1:Point , p2:Point ):int{
			var nx:Number=p1.x-p2.x ;
			var ny:Number=p1.y-p2.y ;
			var r:Number=Math.sqrt(nx*nx+ny*ny);
			var cos:Number=nx/r;
			var angle:int=int(Math.floor(Math.acos(cos)*180/Math.PI));
			
			if(ny<0){
				angle=360-angle;
			}
			
			if(angle>270 )
			{
				return 6;
			}else if(angle>180)	{
				return 4;	
			}else if(angle>90){
				return 2 ;
			}else {
				return 8 ;
			}
			
		}
	}
}