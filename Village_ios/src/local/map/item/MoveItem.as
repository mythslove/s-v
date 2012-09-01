package local.map.item
{
	import bing.iso.IsoUtils;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import local.comm.GameSetting;
	import local.map.cell.MoveItemAnimObject;
	import local.model.MapGridDataModel;
	import local.util.GameUtil;
	import local.vo.BitmapAnimResVO;
	
	/**
	 * 可以移动的对象 
	 * @author zhouzhanglin
	 */	
	public class MoveItem extends BaseMapObject
	{
		public static const CHARACTER_ROADS:Vector.<Point>= Vector.<Point>(
			[ new Point(0,5) , new Point(45,25) , new Point(0,45) , new Point(-45,25) ]
		);
		public static const CAR_ROADS:Vector.<Point>= Vector.<Point>(
			[ new Point(0,20) , new Point(30,25) , new Point(0,30) , new Point(-30,25) ]
		);
		
		protected var _speed:Number = .3 ;
		protected var _nextPoint:Point;
		protected var _animObject:MoveItemAnimObject ;
		protected var _itemLayer:Sprite ;
		protected var _firstMove:Boolean;
		protected var _rightDirection:Boolean =true ; //是否是顺时针方向转
		protected var _roads:Vector.<Point> ;
		protected var _roadIndex:int ;
		protected var _currNode:Point = new Point(); //当前的node位置
		
		public function MoveItem( vo:BitmapAnimResVO )
		{
			super(GameSetting.GRID_SIZE);
			mouseChildren = mouseEnabled=false;
			
			_itemLayer = new Sprite();
			addChild(_itemLayer);
			
			_animObject = new MoveItemAnimObject( vo );
			_animObject.x = vo.offsetX ;
			_animObject.y = vo.offsetY ;
			_itemLayer.addChild(_animObject);
		}
		
		/** 在位置设置后调用 */
		public function init():void{}
		
		override public function update():void
		{
			super.update() ;
			_animObject.update();
			if(_nextPoint){
				moveToPoint();
			}else{
				findNextRoad();
			}
		}
		
		protected function findNextRoad():void
		{
			getNextPoint() ;
			if(_nextPoint){
				var forward:int = GameUtil.getDirection4(  _nextPoint.x ,_nextPoint.y , screenX,screenY );
				_animObject.forward = forward ;
			}
		}
		
		protected function moveToPoint():void
		{
			var distance:Number = Point.distance( _nextPoint , new Point(screenX,screenY) ) ;
			if(distance < _speed){
				_nextPoint = null; 
				if(_firstMove){
					sort();
					_firstMove = false ;
				}
			} else {
				var moveNum:Number = distance/_speed ;
				this.setScreenPosition( screenX+(_nextPoint.x - screenX)/moveNum , screenY+(_nextPoint.y - screenY)/moveNum );
			}
		}
		
		/*下一个点*/
		protected function getNextPoint():void
		{
			var xpos:Number = screenY + screenX * .5;
			var zpos:Number = screenY - screenX * .5;
			var col:Number = (xpos / _size )>>0 ;
			var row:Number = ( zpos / _size)>>0 ;
			_currNode.setTo( col , row );
			xpos = _currNode.x*_size ;
			zpos = _currNode.y*_size ;
			
			var road:Road ;
			if(_roadIndex==0)
			{
				if(_rightDirection){
					if(_animObject.forward==4 || Math.random()>0.8 ){
						road = MapGridDataModel.instance.getBuildingByData( (_currNode.x-1)*_size, zpos) as Road;
						if(road) _roadIndex = 1 ; 
					}
					if(!road) _roadIndex = 3 ;
				} 
				else 
				{
					if(_animObject.forward==1|| Math.random()>0.8 ){
						road = MapGridDataModel.instance.getBuildingByData(xpos,(_currNode.y-1)*_size) as Road;
						if(road) _roadIndex = 3 ;
					}
					if(!road) _roadIndex = 1 ;
				}
			}
			else if(_roadIndex==1)
			{
				if(_rightDirection){
					if(_animObject.forward==1|| Math.random()>0.8 ){
						road = MapGridDataModel.instance.getBuildingByData( xpos, (_currNode.y-1) *_size) as Road;
						if(road) _roadIndex = 2 ;
					}
					if(!road)  _roadIndex = 0 ;
				}
				else
				{
					if(_animObject.forward==2|| Math.random()>0.8 ){
						road = MapGridDataModel.instance.getBuildingByData( (_currNode.x+1)*_size,zpos) as Road;
						if(road) _roadIndex = 0 ;
					}
					if(!road) _roadIndex = 2 ;
				}
			}
			else if(_roadIndex==2)
			{
				if(_rightDirection)
				{
					if(_animObject.forward==2|| Math.random()>0.8 ){
						road = MapGridDataModel.instance.getBuildingByData( (_currNode.x+1)*_size, zpos) as Road;
						if(road) _roadIndex = 3 ;
					}
					if(!road)	_roadIndex = 1;
				}
				else
				{
					if(_animObject.forward==3|| Math.random()>0.8 ){
						road = MapGridDataModel.instance.getBuildingByData( xpos, (_currNode.y+1)*_size) as Road;
						if(road) _roadIndex = 1 ;
					}
					if(!road) _roadIndex = 3 ;
				}
			}
			else
			{
				if(_rightDirection){
					if(_animObject.forward==3|| Math.random()>0.8 ){
						road = MapGridDataModel.instance.getBuildingByData(xpos,(_currNode.y+1)*_size) as Road;
						if(road)_roadIndex = 0 ;
					}
					if(!road) _roadIndex = 2 ;
				}
				else
				{
					if(_animObject.forward==4|| Math.random()>0.8 ){
						road = MapGridDataModel.instance.getBuildingByData( (_currNode.x-1)*_size,zpos) as Road;
						if(road)	_roadIndex = 2;
					}
					if(!road)_roadIndex =0 ;
				}
			}
			
			_nextPoint = new Point();
			if(road){
				_nextPoint.x = road.screenX + _roads[_roadIndex].x  ;
				_nextPoint.y = road.screenY + _roads[_roadIndex].y  ;
				_firstMove = true ;
			}else{
				_nextPoint.x = xpos - zpos +_roads[_roadIndex].x ;
				_nextPoint.y = (xpos+ zpos) * .5 + _roads[_roadIndex].y;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			_animObject.dispose() ;
			_animObject = null ;
			_nextPoint = null ;
			_currNode = null ;
			_roads = null ;
			_itemLayer = null ;
		}
	}
}