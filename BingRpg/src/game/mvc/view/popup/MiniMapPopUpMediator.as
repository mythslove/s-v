package game.mvc.view.popup
{
	import bing.utils.ContainerUtil;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.events.HeroEvent;
	import game.global.GameData;
	import game.global.Resource;
	import game.mvc.base.GameMediator;
	import game.mvc.model.MapDataModel;
	import game.mvc.model.vo.MapVO;
	
	public class MiniMapPopUpMediator extends GameMediator
	{
		public function get miniMapPop():MiniMapPopUp
		{
			return view as MiniMapPopUp ;
		}
		public function MiniMapPopUpMediator(view:DisplayObjectContainer)
		{
			super(view);
		}
		
		private var _scale:Number ;
		private var _flag:Bitmap ;
		private var _heroPoint:Bitmap ;
		
		override public function onRegister():void
		{
			//添加英雄所在的位置
			_scale = MapDataModel.instance.currentMapVO.scale; 
			_heroPoint = new Resource.MiniMapPopupHeroPoint() ;
			view.addChild( _heroPoint );
			
			_flag = new Resource.MiniFlag() ;
			
			view.addEventListener(Event.ENTER_FRAME , update );
			//点击小地图侦听，寻路
			miniMapPop.container.addEventListener(MouseEvent.CLICK , miniMapClickHandler);
			//英雄到达目的地
			this.addContextListener( HeroEvent.ARRIVED_DESTINATION , arrivedDesHandler );
		}
		
		private function update(e:Event):void 
		{
			_heroPoint.x = GameData.hero.x/_scale+miniMapPop.container.x-_heroPoint.width*0.5  ;
			_heroPoint.y = GameData.hero.y/_scale+miniMapPop.container.y-_heroPoint.height*0.5 ;
		}
		
		private function shapePoint( color:uint , radius:int , x:Number , y:Number ):Shape
		{
			var shape:Shape = new Shape();
			shape.graphics.beginFill( color );
			shape.graphics.drawCircle(0,0,radius );
			shape.graphics.endFill() ;
			shape.x = x ;
			shape. y = y ;
			return shape ;
		}
		
		private function arrivedDesHandler( e:HeroEvent ):void
		{
			ContainerUtil.removeChildren( miniMapPop.pointContainer );
			miniMapPop.pointContainer.graphics.clear() ;
		}
		
		private function miniMapClickHandler(e:MouseEvent):void 
		{
			e.stopPropagation() ;
			
			if(GameData.hero && checkMouseRegion(e.localX*_scale,e.localY*_scale))
			{
				if( GameData.hero.findAndMove( e.localX*_scale , e.localY*_scale ))
				{
					ContainerUtil.removeChildren( miniMapPop.pointContainer );
					
					_flag.x = e.localX+miniMapPop.pointContainer.x-4 ;
					_flag.y = e.localY+miniMapPop.pointContainer.y-20 ;
					miniMapPop.pointContainer.addChild( _flag );
					//显示路径
					miniMapPop.pointContainer.graphics.clear() ;
					miniMapPop.pointContainer.graphics.lineStyle(2,0xffcc00);
					miniMapPop.pointContainer.graphics.moveTo( GameData.hero.x/_scale , GameData.hero.y/_scale);
					const LEN:int = GameData.hero.roads.length; 
					var point:Object ;
					for( var i:int = 0 ; i<LEN ; i++)
					{
						point = GameData.hero.roads[i] ;
						miniMapPop.pointContainer.graphics.lineTo(point.x/_scale ,point.y/_scale);
					}
				}
			}
		}
		
		//鼠标点击应该在合理的范围内
		private function checkMouseRegion(px:Number,py:Number):Boolean
		{
			var mapVO:MapVO = MapDataModel.instance.currentMapVO ;
			if(px<mapVO.tileWidth || py<mapVO.tileHeight){
				return false ;
			}
			if( px>mapVO.mapWidth-mapVO.tileWidth || py>mapVO.mapHeight-mapVO.tileHeight)
			{
				return false ;
			}
			return true ;
		}
		
		override public function dispose():void
		{
			this.removeContextListener( HeroEvent.ARRIVED_DESTINATION , arrivedDesHandler );
			view.removeEventListener(Event.ENTER_FRAME , update );
			miniMapPop.container.removeEventListener(MouseEvent.CLICK , miniMapClickHandler);
			super.dispose() ;
		}
	}
}