package local.map.item
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.enum.BuildingType;
	import local.map.cell.MoveItemAnimObject;
	import local.model.MapGridDataModel;
	import local.util.GameUtil;
	import local.vo.BitmapAnimResVO;
	
	/**
	 * 可以移动的对象
	 * 人物正面朝向forward
	 * 4	1
	 * 3	2
	 * 在菱形块的索引位置_roadIndex
	 *		0
	 * 3		1
	 * 		2
	 * @author zhouzhanglin
	 */	
	public class MoveItem extends BaseMapObject
	{
		public static const CHARACTER_ROADS:Vector.<Point>= Vector.<Point>(
			[ new Point(0,5) , new Point(45,25) , new Point(0,45) , new Point(-45,25) ]
		);
		public static const CAR_ROADS:Vector.<Point>= Vector.<Point>(
			[  new Point(0,15) , new Point(23,25) , new Point(0,35) , new Point(-23,25) ]
		);
		
		protected var _speed:Number = 0.3 ;
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
			_xSpan = _zSpan = 0 ;
			mouseChildren = mouseEnabled=false;
			
			_itemLayer = new Sprite();
			addChild(_itemLayer);
			
			var actionNun:int = (this is Car) ? 1 : 4 ; 
			_animObject = new MoveItemAnimObject( vo, actionNun );
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
		
		/** 找下一条路 */
		protected function findNextRoad():void
		{
			getNextPoint() ;
			if(_nextPoint){
				var forward:int = GameUtil.getDirection4(  _nextPoint.x ,_nextPoint.y , screenX,screenY );
				_animObject.forward = forward ;
			}
		}
		
		/** 移动到一个点 */
		protected function moveToPoint():void
		{
			GameData.commPoint.x = screenX ;
			GameData.commPoint.y = screenY ;
			var distance:Number = Point.distance( _nextPoint , GameData.commPoint ) ;
			if(distance < _speed){
				_nextPoint = null; 
				sort();
			} else {
				var moveNum:Number = distance/_speed ;
				this.setScreenPosition( screenX+(_nextPoint.x - screenX)/moveNum , screenY+(_nextPoint.y - screenY)/moveNum );
				if(_firstMove){
					sort();
					_firstMove = false ;
				}
			}
		}
		
		/** 找下一个路点 */
		protected function getNextPoint():void
		{
			var xpos:Number = screenY + screenX * .5;
			var zpos:Number = screenY - screenX * .5;
			var col:Number = (xpos / _size )>>0 ;
			var row:Number = ( zpos / _size)>>0 ;
			_currNode.setTo( col , row );
			xpos = _currNode.x*_size ;
			zpos = _currNode.y*_size ;
			var ran:Number = 0.3 ;
			var road:Road ;
			if(_roadIndex==0)
			{
				if(_rightDirection){
					if(_animObject.forward==4 || Math.random()>ran ){
						road = MapGridDataModel.instance.getBuildingByData( (_currNode.x-1)*_size, zpos , BuildingType.DECORATION_ROAD ) as Road;
						if(road) _roadIndex = 1 ; 
					}
					if(!road) _roadIndex = 3 ;
				} 
				else 
				{
					if(_animObject.forward==1|| Math.random()>ran ){
						road = MapGridDataModel.instance.getBuildingByData(xpos,(_currNode.y-1)*_size , BuildingType.DECORATION_ROAD) as Road;
						if(road) _roadIndex = 3 ;
					}
					if(!road) _roadIndex = 1 ;
				}
			}
			else if(_roadIndex==1)
			{
				if(_rightDirection){
					if(_animObject.forward==1|| Math.random()>ran ){
						road = MapGridDataModel.instance.getBuildingByData( xpos, (_currNode.y-1) *_size , BuildingType.DECORATION_ROAD) as Road;
						if(road) _roadIndex = 2 ;
					}
					if(!road)  _roadIndex = 0 ;
				}
				else
				{
					if(_animObject.forward==2|| Math.random()>ran ){
						road = MapGridDataModel.instance.getBuildingByData( (_currNode.x+1)*_size,zpos , BuildingType.DECORATION_ROAD) as Road;
						if(road) _roadIndex = 0 ;
					}
					if(!road) _roadIndex = 2 ;
				}
			}
			else if(_roadIndex==2)
			{
				if(_rightDirection)
				{
					if(_animObject.forward==2|| Math.random()>ran ){
						road = MapGridDataModel.instance.getBuildingByData( (_currNode.x+1)*_size, zpos , BuildingType.DECORATION_ROAD) as Road;
						if(road) _roadIndex = 3 ;
					}
					if(!road)	_roadIndex = 1;
				}
				else
				{
					if(_animObject.forward==3|| Math.random()>ran ){
						road = MapGridDataModel.instance.getBuildingByData( xpos, (_currNode.y+1)*_size , BuildingType.DECORATION_ROAD ) as Road;
						if(road) _roadIndex = 1 ;
					}
					if(!road) _roadIndex = 3 ;
				}
			}
			else
			{
				if(_rightDirection){
					if(_animObject.forward==3|| Math.random()>ran ){
						road = MapGridDataModel.instance.getBuildingByData(xpos,(_currNode.y+1)*_size , BuildingType.DECORATION_ROAD) as Road;
						if(road)_roadIndex = 0 ;
					}
					if(!road) _roadIndex = 2 ;
				}
				else
				{
					if(_animObject.forward==4|| Math.random()>ran ){
						road = MapGridDataModel.instance.getBuildingByData( (_currNode.x-1)*_size,zpos , BuildingType.DECORATION_ROAD) as Road;
						if(road)	_roadIndex = 2;
					}
					if(!road)_roadIndex =0 ;
				}
			}
			
			_firstMove = true ;
			_nextPoint = new Point();
			if(road){
				_nextPoint.x = road.screenX + _roads[_roadIndex].x  ;
				_nextPoint.y = road.screenY + _roads[_roadIndex].y  ;
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