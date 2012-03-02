package local.game.elements
{
	import bing.iso.path.AStar;
	import bing.iso.path.Node;
	import bing.utils.ContainerUtil;
	import bing.utils.MathUtil;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import local.comm.GameSetting;
	import local.enum.AvatarAction;
	import local.game.cell.BitmapMovieClip;
	import local.model.buildings.vos.BuildingVO;
	import local.model.map.MapGridDataModel;
	import local.utils.ResourceUtil;
	
	/**
	 * 地图上的人 
	 * @author zzhanglin
	 */	
	public class Character extends Building
	{
		protected var _bmpMC:BitmapMovieClip;
		protected var _currentActions:String ;
		public var roads:Array ; //路
		public var speed:Number = 4.6 ;
		public var nextPoint:Node ; //下一个坐标
		protected var roadIndex:int =0 ;
		
		public function Character(vo:BuildingVO)
		{
			super(vo);
		}
		
		/**
		 * 移动到一个点 
		 * @param point
		 * @return 是否到达该点
		 */		
		public function moveToPoint( point:Node):Boolean 
		{
			var distance:Number = MathUtil.distance(x,z,point.x,point.y );
			if(distance < speed){
				gotoAndPlay(AvatarAction.IDLE) ;
				return true;
			}
			if( point.y>=screenY ){
				if(_currentActions!=AvatarAction.WALK){
					gotoAndPlay(AvatarAction.WALK);
				}
			}else{
				if(_currentActions!=AvatarAction.WALKBACK){
					gotoAndPlay(AvatarAction.WALKBACK);
				}
			}
			var moveNum:Number = distance/this.speed ;
			x += ( (point.x - x)/moveNum)>>0 ;
			z += ( (point.y - z)/moveNum)>>0 ;
			return false;	
		}
		
		public function searchToRun( endNodeX:int , endNodeZ:int ):void
		{
			var astar:AStar = new AStar();
			MapGridDataModel.instance.astarGrid.setStartNode( nodeX,nodeZ );
			MapGridDataModel.instance.astarGrid.setEndNode( endNodeX,endNodeZ );
			if(astar.findPath(MapGridDataModel.instance.astarGrid )) 
			{
				var roadsArray:Array = astar.path;
				if(roadsArray && roadsArray.length>1){
					this.roads = roadsArray ;
					roadIndex = 0 ;
					this.getNextPoint();
					nextPoint = this.getNextPoint();
				}
			}
		}
		
		/**
		 * 通过点来移动 
		 * @param roads
		 */		
		public function moveByRoads( roads:Array ):void 
		{
			roadIndex = 0 ;
			this.roads = roads ;
			this.nextPoint = getNextPoint() ; 
		}
		
		/**
		 * 不断移动 
		 */		
		public function move():void
		{
			if( moveToPoint(nextPoint) ){
				nextPoint = getNextPoint() ; //取下一个点
			}
		}
		
		/**
		 * 从路中取出一个点 
		 * @return 
		 */		
		protected function getNextPoint():Node
		{
			roadIndex++;
			if(roadIndex<roads.length){
				var p:Node = roads[roadIndex] as Node ;
				p.x*= GameSetting.GRID_SIZE;
				p.y*= GameSetting.GRID_SIZE ;
				return p ;
			}
			else(roads.length>=roadIndex)
			{
				roads = null ;
				nextPoint = null ;
				return null ;
			}
		}
		
		/**
		 * 停止移动 
		 */		
		public function stopMove():void 
		{
			roads = null ;
		}
		
		
		
		
		
		
		/* 加载资源完成*/
		override protected function resLoadedHandler( e:Event ):void
		{
			ResourceUtil.instance.removeEventListener( buildingVO.baseVO.alias , resLoadedHandler );
			ContainerUtil.removeChildren(itemLayer);
			//获取元件
			_skin = ResourceUtil.instance.getInstanceByClassName( buildingVO.baseVO.alias , buildingVO.baseVO.alias ) as MovieClip;
			if(_skin){
				_bmpMC = new BitmapMovieClip(_skin);
				itemLayer.addChild(_bmpMC);
				gotoAndPlay( AvatarAction.IDLE );
			}
		}
		
		/**
		 * 播放动作 
		 * @param action
		 */		
		public function gotoAndPlay( action:String ):void
		{
			if(_skin){
				_currentActions = action ;
				_skin.gotoAndPlay( action);
			}
		}
		
		override public function update():void
		{
			if(_bmpMC){
				if(_skin.currentFrameLabel && _skin.currentFrameLabel!=_currentActions){
					_skin.gotoAndPlay( _currentActions);
				}
				_bmpMC.update();
				var rect:Rectangle = _bmpMC.getBound();
				_bmpMC.x = rect.x ;
				_bmpMC.y = rect.y ;
			}
			if( roads && nextPoint ){
				move();
			}
		}
		
		override public function dispose():void
		{
			if(_bmpMC){
				_bmpMC.dispose();
				_bmpMC = null ;
			}
			super.dispose();
		}
	}
}