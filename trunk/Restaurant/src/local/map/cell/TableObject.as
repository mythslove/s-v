package local.map.cell
{
	import starling.animation.IAnimatable;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	
	public class TableObject extends Sprite implements IAnimatable
	{
		public function TableObject()
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