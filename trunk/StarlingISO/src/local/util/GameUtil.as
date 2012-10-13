package local.util
{
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;

	public class GameUtil
	{
		public static function dark( container:DisplayObjectContainer ):void
		{
			for( var i:int  = 0 ; i<container.numChildren ; ++i )
			{
				if(container.getChildAt(i) is Quad ){
					(container.getChildAt(i) as Quad).color = 0x666666 ;
				}else if(container.getChildAt(i) is DisplayObjectContainer){
					dark(container.getChildAt(i) as DisplayObjectContainer) ;
				}
			}
		}
		public static function light( container:DisplayObjectContainer ):void{
			for( var i:int  = 0 ; i<container.numChildren ; ++i )
			{
				if(container.getChildAt(i) is Quad ){
					(container.getChildAt(i) as Quad).color = 0xffffff ;
				} else if(container.getChildAt(i) is DisplayObjectContainer){
					light(container.getChildAt(i) as DisplayObjectContainer) ;
				}
			}
		}
	}
}