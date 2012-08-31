package local.map.item
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
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
		protected var _speed:Number = .3 ;
		protected var _nextPoint:Point;
		protected var _animObject:MoveItemAnimObject ;
		protected var _itemLayer:Sprite ;
		protected var _firstMove:Boolean;
		
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
			var road:Road = findRandomRoad() ;
			if(road){
				_nextPoint = new Point( road.x ,road.z );
				_firstMove = true ;
				var forward:int = GameUtil.getDirection4(  road.screenX,road.screenY , screenX,screenY );
				_animObject.forward = forward ;
			}
		}
		
		protected function moveToPoint():void
		{
			var distance:Number = Point.distance(_nextPoint , new Point(x,z)) ;
			if(distance < _speed){
				x = _nextPoint.x;
				z = _nextPoint.y ;
				_nextPoint = null; 
			} else {
				var moveNum:Number = distance/_speed ;
				this.x +=  (_nextPoint.x - x)/moveNum ;
				this.z +=  (_nextPoint.y - z)/moveNum ;
				if(_firstMove){
					sort();
					_firstMove = false ;
				}
			}
		}
		
		/* 随机方向的路*/
		protected function findRandomRoad():Road
		{
			var roadArray:Array=[];
			var road:Road ;
			if(_animObject.forward==1)
			{
				road = MapGridDataModel.instance.getBuildingByData(nodeX*GameSetting.GRID_SIZE,(nodeZ-1)*GameSetting.GRID_SIZE) as Road;
				if(road) roadArray.push( road );
				road = MapGridDataModel.instance.getBuildingByData((nodeX-1)*GameSetting.GRID_SIZE,nodeZ*GameSetting.GRID_SIZE) as Road;
				if(road) roadArray.push( road );
				road = MapGridDataModel.instance.getBuildingByData((nodeX+1)*GameSetting.GRID_SIZE,nodeZ*GameSetting.GRID_SIZE) as Road;
				if(road) roadArray.push( road );
				if(roadArray.length==0){
					road = MapGridDataModel.instance.getBuildingByData(nodeX*GameSetting.GRID_SIZE,(nodeZ+1)*GameSetting.GRID_SIZE) as Road;
					if(road) roadArray.push( road );
				}
			}
			else if(_animObject.forward==2)
			{
				road = MapGridDataModel.instance.getBuildingByData((nodeX+1)*GameSetting.GRID_SIZE,nodeZ*GameSetting.GRID_SIZE) as Road;
				if(road) roadArray.push( road );
				road = MapGridDataModel.instance.getBuildingByData(nodeX*GameSetting.GRID_SIZE,(nodeZ-1)*GameSetting.GRID_SIZE) as Road;
				if(road) roadArray.push( road );
				road = MapGridDataModel.instance.getBuildingByData(nodeX*GameSetting.GRID_SIZE,(nodeZ+1)*GameSetting.GRID_SIZE) as Road;
				if(road) roadArray.push( road );
				if(roadArray.length==0){
					road = MapGridDataModel.instance.getBuildingByData((nodeX-1)*GameSetting.GRID_SIZE,nodeZ*GameSetting.GRID_SIZE) as Road;
					if(road) roadArray.push( road );
				}
			}
			else if(_animObject.forward==3)
			{
				road = MapGridDataModel.instance.getBuildingByData(nodeX*GameSetting.GRID_SIZE,(nodeZ+1)*GameSetting.GRID_SIZE) as Road;
				if(road) roadArray.push( road );
				road = MapGridDataModel.instance.getBuildingByData((nodeX+1)*GameSetting.GRID_SIZE,nodeZ*GameSetting.GRID_SIZE) as Road;
				if(road) roadArray.push( road );
				road = MapGridDataModel.instance.getBuildingByData((nodeX-1)*GameSetting.GRID_SIZE,nodeZ*GameSetting.GRID_SIZE) as Road;
				if(road) roadArray.push( road );
				if(roadArray.length==0){
					road = MapGridDataModel.instance.getBuildingByData(nodeX*GameSetting.GRID_SIZE,(nodeZ-1)*GameSetting.GRID_SIZE) as Road;
					if(road) roadArray.push( road );
				}
			}
			else
			{
				road = MapGridDataModel.instance.getBuildingByData((nodeX-1)*GameSetting.GRID_SIZE,nodeZ*GameSetting.GRID_SIZE) as Road;
				if(road) roadArray.push( road );
				road = MapGridDataModel.instance.getBuildingByData(nodeX*GameSetting.GRID_SIZE,(nodeZ+1)*GameSetting.GRID_SIZE) as Road;
				if(road) roadArray.push( road );
				road = MapGridDataModel.instance.getBuildingByData(nodeX*GameSetting.GRID_SIZE,(nodeZ-1)*GameSetting.GRID_SIZE) as Road;
				if(road) roadArray.push( road );
				if(roadArray.length==0){
					road = MapGridDataModel.instance.getBuildingByData((nodeX+1)*GameSetting.GRID_SIZE,nodeZ*GameSetting.GRID_SIZE) as Road;
					if(road) roadArray.push( road );
				}
			}
			if(roadArray.length>0)
			{
				var index:int=Math.round( (roadArray.length-1)*Math.random() );
				return roadArray[index] ;
			}
			return null ;
		}
		
		override public function dispose():void
		{
			super.dispose();
			_animObject.dispose() ;
			_animObject = null ;
			_nextPoint = null ;
		}
	}
}