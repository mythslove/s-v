package local.map.cell
{
	import starling.animation.IAnimatable;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	
	/**
	 * 柜台上的物品 
	 * @author zhouzhanglin
	 */	
	public class CounterObject extends Sprite implements IAnimatable
	{
		public function CounterObject()
		{
			super();
		}
		
		public function advanceTime(passedTime:Number):void
		{
			for( var i:int = 0 ; i<numChildren ; ++i){
				if(getChildAt(i) is MovieClip ){
					( getChildAt(i) as MovieClip ).advanceTime( passedTime );
				}
			}
		}
	}
}