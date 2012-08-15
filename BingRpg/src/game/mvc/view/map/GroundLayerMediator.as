package game.mvc.view.map
{
	import bing.utils.ContainerUtil;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	
	import game.elements.ground.Block;
	import game.events.ChangeMapEvent;
	import game.mvc.base.GameMediator;
	import game.mvc.model.MapDataModel;
	import game.mvc.model.vo.MapVO;
	
	public class GroundLayerMediator extends GameMediator
	{
		private var _bigMap:Bitmap ;
		
		public function get groundLayer():GroundLayer
		{
			return view as GroundLayer ;
		}
		
		public function GroundLayerMediator(view:DisplayObjectContainer)
		{
			super(view);
		}
		
		override public function onRegister():void
		{
			super.onRegister() ;
			this.addContextListener( ChangeMapEvent.CHANGE_MAP_OVER , changeMapOverHandler );
		}
		
		
		private function changeMapOverHandler(e:ChangeMapEvent):void
		{
			ContainerUtil.removeChildren( view );
			this.groundLayer.graphics.clear();
			//添加块或大图片
			if(MapDataModel.instance.currentMapVO.segmentation){
				//画马赛克
				var mapVO:MapVO = MapDataModel.instance.currentMapVO ;
				var matrix:Matrix = new Matrix();
				matrix.scale( mapVO.scale,mapVO.scale);
				this.groundLayer.graphics.beginBitmapFill( MapDataModel.instance.miniMap.bitmapData,matrix);
				this.groundLayer.graphics.drawRect(0,0,mapVO.mapWidth,mapVO.mapHeight);
				this.groundLayer.graphics.endFill();
				for each( var block:Block in MapDataModel.instance.mapBlocks)
				{
					view.addChild( block );
				}
			}
			else
			{
				_bigMap = MapDataModel.instance.bigMap ;
				view.addChild(_bigMap);
			}
		}
	}
}