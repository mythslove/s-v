package local.views
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Sprite;
	import flash.utils.setTimeout;
	
	import local.comm.GameSetting;
	import local.comm.GlobalDispatcher;
	import local.comm.GlobalEvent;
	import local.model.vos.PickupVO;
	import local.views.collection.CollectionHud;

	public class RightBar extends BaseView
	{
		private static var _instance:RightBar ;
		public static function get instance():RightBar
		{
			if(!_instance) _instance = new RightBar();
			return _instance;
		}
		
		//================================
		public var collectionHud:CollectionHud ;
		
		public function RightBar()
		{
			super();
			if(_instance) throw new Error(" 只能实例化一个RightBar");
			else _instance = this ;
			mouseEnabled = false ;
		}
		
		override protected function added():void
		{
			x = stage.stageWidth ;
			
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
		
		public function showCollectionHud( pvo:PickupVO ):void{
			collectionHud.visible = true ;
			collectionHud.show(pvo);
			collectionHud.x = 0 ;
			TweenLite.to(collectionHud,0.3,{x: 60-collectionHud.width, ease:Back.easeOut});
		}
	}
}