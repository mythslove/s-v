package game.mvc.view.popup
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import game.mvc.model.MapDataModel;
	import game.mvc.view.components.BaseView;
	
	public class MiniMapPopUp extends BaseView
	{
		private var _mediator:MiniMapPopUpMediator ;
		
		public var container:Sprite ;
		public var miniMapBmp:Bitmap;
		public var pointContainer:Sprite ;
		
		public function MiniMapPopUp()
		{
			super();
			_mediator = new MiniMapPopUpMediator( this );
			initView();
		}
		
		private function initView():void 
		{
			container = new Sprite();
			addChild(container);
			
			pointContainer = new Sprite();
			pointContainer.mouseChildren = pointContainer.mouseEnabled = false ;
			addChild(pointContainer);
			
			//获得小地图图片
			miniMapBmp = new Bitmap(MapDataModel.instance.miniMap.bitmapData);
			container.addChild( miniMapBmp);
		}
		
		override protected function removeFromStage():void
		{
			_mediator.dispose();
			miniMapBmp = null ;
		}
	}
}