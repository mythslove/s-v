package local.game.elements
{
	import bing.iso.path.AStar;
	import bing.iso.path.Node;
	import bing.utils.ContainerUtil;
	import bing.utils.MathUtil;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import local.comm.GameSetting;
	import local.enum.AvatarAction;
	import local.game.GameWorld;
	import local.game.cell.BitmapMovieClip;
	import local.game.scenes.BuildingScene;
	import local.model.buildings.vos.BuildingVO;
	import local.model.map.MapGridDataModel;
	import local.utils.CollectQueueUtil;
	import local.utils.ResourceUtil;
	
	/**
	 * 地图上的人 
	 * @author zzhanglin
	 */	
	public class Character extends Building
	{
		protected var _bmpMC:BitmapMovieClip;
		protected var _currentActions:String ;
		protected var _roads:Array ; //路
		public var speed:Number = 6 ;
		public var nextPoint:Node ; //下一个坐标
		protected var roadIndex:int =0 ;
		private var _firstMove:Boolean;
		
		public function Character(vo:BuildingVO)
		{
			super(vo);
			itemLayer.y = 20;
		}
		
		public function set roads( value:Array ):void
		{
			_roads = value ;
			if(value==null){
				gotoAndPlay(AvatarAction.IDLE) ;
			} 
		}
		public function get roads():Array{
			return _roads ;
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
				//判断当前在哪个BuildingScene上
				var scene:BuildingScene = GameWorld.instance.getBuildingScene(nodeX,nodeZ);
				if(scene && parent !=scene ){
					(parent as BuildingScene).removeIsoObject( this );
					scene.addIsoObject( this );
				}else{
					this.sort();
				}
				return true;
			}
			if(_currentActions!=AvatarAction.WALK){
				gotoAndPlay(AvatarAction.WALK);
			}
			var moveNum:Number = distance/this.speed ;
			x += ( (point.x - x)/moveNum)>>0 ;
			z += ( (point.y - z)/moveNum)>>0 ;
			if(_firstMove){
				this.sort();
				_firstMove = false ;
			}
			return false;	
		}
		
		/**
		 * 寻路移动 
		 * @param endNodeX
		 * @param endNodeZ
		 * @return true表示有路径，false为没有路
		 */		
		public function searchToRun( endNodeX:int , endNodeZ:int):Boolean
		{
			if(endNodeX<0 || endNodeZ<0||endNodeX+1>GameSetting.GRID_X||endNodeZ+1>GameSetting.GRID_Z ) return false;
			if(MapGridDataModel.instance.astarGrid.getNode(endNodeX,endNodeZ).walkable )
			{
				if(MapGridDataModel.instance.astarGrid.getNode(nodeX,nodeZ).walkable)
				{
					var astar:AStar = new AStar();
					MapGridDataModel.instance.astarGrid.setStartNode( nodeX,nodeZ );
					MapGridDataModel.instance.astarGrid.setEndNode( endNodeX,endNodeZ );
					if(astar.findPath(MapGridDataModel.instance.astarGrid )) 
					{
						var roadsArray:Array = astar.path;
						if(roadsArray && roadsArray.length>0){
							roads = roadsArray ;
							roadIndex = 0 ;
							nextPoint = this.getNextPoint();
							return true;
						}
					}
				}else if(_currentActions==AvatarAction.IDLE){
					nodeX=endNodeX;
					nodeZ = endNodeZ;
					gotoAndPlay(AvatarAction.IDLE);
					sort();
				}
			}
			return false;
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
			if(!roads) {
				arrived();
				return null ;
			}
			roadIndex++;
			if(roadIndex<roads.length){
				var p:Node = (roads[roadIndex] as Node).clone() ;
				p.x*= GameSetting.GRID_SIZE;
				p.y*= GameSetting.GRID_SIZE ;
				_firstMove = true ;
				return p ;
			}
			else(roads.length>=roadIndex)
			{
				if(nextPoint){
					x= nextPoint.x ;
					z = nextPoint.y ;
				}
				roads = null ;
				nextPoint = null ;
				gotoAndPlay(AvatarAction.IDLE) ;
				arrived();
				return null ;
			}
		}
		
		/**
		 * 到达目的地了
		 * */
		protected function arrived():void{
			
		}
		
		/**
		 * 停止移动 
		 */		
		public function stopMove():void 
		{
			roads = null ;
			gotoAndPlay(AvatarAction.IDLE) ;
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