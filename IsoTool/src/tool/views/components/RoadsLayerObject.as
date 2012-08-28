package tool.views.components
{
	import bing.utils.ContainerUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import tool.local.vos.BitmapAnimResVO;

	/**
	 * 路点层 
	 * @author zhouzhanglin
	 */	
	public class RoadsLayerObject extends AnimObject
	{
		
		public function RoadsLayerObject()
		{
			super();
			this.hitArea = this ;
		}
		
		/**
		 * 绘制路径 
		 */		
		public function refresh():void
		{
			ContainerUtil.removeChildren(this);
			var render:PointRenderer ;
			var len:int = vo.roads.length ;
			if(len>0)
			{
				var p:Point = vo.roads[0];
				render = new PointRenderer( p );
				render.x = p.x ;
				render.y = p.y ;
				addChild(render);
				
				graphics.clear() ;
				graphics.lineStyle(3,0xffffff);
				graphics.moveTo( p.x,p.y);
				for( var i:int = 1 ; i<len ; ++i )
				{
					p = vo.roads[i] ;
					graphics.lineTo( p.x , p.y );
					render = new PointRenderer( p );
					render.x = p.x ;
					render.y = p.y ;
					addChild(render);
				}
			}
		}
		
		
		protected function onMouseHandler( e:MouseEvent ):void
		{
			if(e.target is PointRenderer)
			{
				var render:PointRenderer = e.target as PointRenderer ;
				switch( e.type)
				{
					case MouseEvent.MOUSE_OUT:
						render.alpha = 1 ;
						break ;
					case MouseEvent.MOUSE_OVER:
						render.alpha = 0.5 ;
						break ;
					case MouseEvent.MOUSE_DOWN:
						render.startDrag(false);
						break ;
					case MouseEvent.MOUSE_UP:
						render.alpha = 1 ;
						render.stopDrag() ;
						var wid:int = (parent.parent.width-parent.x)/2 ;
						var het:int = (parent.parent.height-parent.y)/2 ;
						if(numChildren>1 && (render.x<-wid || render.x>wid || render.y<-het || render.y>het) )
						{
							for( var i:int = 0 ; i<vo.roads.length ; ++i){
								if(vo.roads[i]==render.p){
									vo.roads.splice( i , 1 );
									break ;
								}
							}
						}
						else
						{
							render.p.x = render.x ;
							render.p.y = render.y ;
						}
						this.refresh() ;
						break ;
				}
			}
		}
		
		
		//==============重写==============================
		
		override public function setAnimResVO(vo:BitmapAnimResVO):void
		{
			this.vo = vo ;
			this.refresh() ;
		}
		
		override protected function addedToStage(e:Event):void
		{
			super.addedToStage(e);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseHandler );
			addEventListener(MouseEvent.MOUSE_DOWN , onMouseHandler );
			addEventListener(MouseEvent.MOUSE_UP , onMouseHandler );
			addEventListener(MouseEvent.MOUSE_OUT , onMouseHandler );
		}
		
		override public function update():void{}
		
		override protected function removedFromStage( e:Event ):void
		{
			super.removedFromStage(e);
			removeEventListener(MouseEvent.MOUSE_OVER, onMouseHandler );
			removeEventListener(MouseEvent.MOUSE_DOWN , onMouseHandler );
			removeEventListener(MouseEvent.MOUSE_UP , onMouseHandler );
			removeEventListener(MouseEvent.MOUSE_OUT , onMouseHandler );
		}
	}
}






//================================

import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;

/**
 * 点
 * @author zhouzhanglin
 */	
class PointRenderer extends Sprite
{
	public var p:Point ;
	
	public function PointRenderer( point:Point)
	{
		this.p = point ;
		graphics.beginFill( 0xffffff );
		graphics.drawCircle(0,0,6);
		graphics.endFill() ;
		
		addEventListener(Event.ADDED_TO_STAGE , addedToStage);
	}
	
	private function addedToStage( e:Event ):void
	{
		removeEventListener(Event.ADDED_TO_STAGE , addedToStage);
		addEventListener( Event.REMOVED_FROM_STAGE , removedFromStage);
	}
	
	private function removedFromStage( e:Event ):void
	{
		removeEventListener( Event.REMOVED_FROM_STAGE , removedFromStage );
		p = null ;
	}
}