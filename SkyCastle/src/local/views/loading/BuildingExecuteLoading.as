package local.views.loading
{
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import local.game.elements.Building;
	
	public class BuildingExecuteLoading extends Sprite
	{
		public var bar:MovieClip;
		//====================
		private static var _instance:BuildingExecuteLoading;
		public static function getInstance(x:int , y:int ):BuildingExecuteLoading{
			if(!_instance) _instance = new BuildingExecuteLoading();
			_instance.y = y;
			_instance.x = x ;
			return _instance;
		}
		
		public static function get instance():BuildingExecuteLoading{
			if(!_instance) _instance = new BuildingExecuteLoading();
			return _instance;
		}
		
		public function BuildingExecuteLoading()
		{
			super();
			mouseChildren=mouseEnabled=false;
			if(_instance) throw new Error("只能有一个实例");
		}
		
		public function setScale( value:Number ):void
		{
			scaleX = scaleY = value ;
		}
		
		public function setTime( time:Number ):BuildingExecuteLoading
		{
			bar.scaleX=0;
			TweenLite.to( bar , time/1000 , {scaleX:1,onComplete:tweenOver});
			return this;
		}
		
		private function tweenOver():void
		{
			if(parent){
				parent.removeChild(this);
			}
		}
	}
}