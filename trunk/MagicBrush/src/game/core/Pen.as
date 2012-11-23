package game.core
{
	import flash.display.Shape;
	import flash.events.Event;
	
	import game.comm.GameSetting;
	import game.gui.screen.AppSceen;
	
	public class Pen extends Shape
	{
		private static var _instance:Pen;
		public static function get instance():Pen{
			if(!_instance) _instance = new Pen();
			return _instance;
		}
		//==========================
		
		public function Pen()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE , addedHander );
			addEventListener(Event.REMOVED_FROM_STAGE , removedHandler );
		}
		
		public function show():void
		{
			
			if(!parent){
				var layer:GraphicsLayer = AppSceen.instance.graphicsLayer ;
				layer.addChild( this );
			}
			this.graphics.clear();
			this.graphics.lineStyle( 3 ,0xffffff,1,true);
			this.graphics.drawCircle( 0,0,GameSetting.penSize );
			this.graphics.endFill();
			alpha = 1 ;
			x = GameSetting.canvasW>>1 ;
			y = GameSetting.canvasH>>1 ;
		}
		
		private function addedHander( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedHander );
			addEventListener(Event.ENTER_FRAME , update );
		}
		
		private function update(e:Event):void
		{
			alpha -= 0.02 ;
			if(alpha<=0){
				if(parent){
					parent.removeChild(this);
				}
			}
		}
		
		private function removedHandler(e:Event):void
		{
			if(parent){
				parent.removeChild(this);
			}
			removeEventListener(Event.ENTER_FRAME , update );
			addEventListener(Event.ADDED_TO_STAGE , addedHander );
		}
	}
}