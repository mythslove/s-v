package local.views
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	
	import local.comm.GameSetting;
	import local.comm.GlobalDispatcher;
	import local.comm.GlobalEvent;
	import local.views.collection.CollectionHud;

	public class RightBar extends BaseView
	{
		public var collectionHud:CollectionHud ;
		
		
		private static var _instance:RightBar ;
		public static function get instance():RightBar
		{
			if(!_instance) _instance = new RightBar();
			return _instance;
		}
		public function RightBar()
		{
			super();
			if(_instance) throw new Error(" 只能实例化一个RightBar");
			else _instance = this ;
			mouseEnabled = false ;
		}
		
		override protected function added():void
		{
			GlobalDispatcher.instance.addEventListener( GlobalEvent.RESIZE , onResizeHandler ) ;
			collectionHud = new CollectionHud();
			collectionHud.y = 100 ;
			collectionHud.visible = false ;
			addChild(collectionHud);
		}
		
		private function onResizeHandler( e:GlobalEvent ):void
		{
			this.x = stage.stageWidth ;
		}
		
		public function showCollectionHud():void{
			collectionHud.x = GameSetting.SCREEN_WIDTH;
			TweenLite.to(collectionHud,0.2,{x:stage.stageWidth-collectionHud.width});
		}
	}
}