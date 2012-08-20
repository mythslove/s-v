package local.game.elements
{
	import bing.iso.IsoScene;
	import bing.iso.path.AStar;
	import bing.iso.path.Node;
	import bing.utils.ContainerUtil;
	import bing.utils.MathUtil;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import local.comm.GameSetting;
	import local.enum.AvatarAction;
	import local.game.GameWorld;
	import local.game.scenes.BuildingScene;
	import local.model.MapGridDataModel;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.EffectManager;
	import local.utils.ResourceUtil;
	import local.views.effects.BitmapMovieClip;
	
	/**
	 * 地图上的人 
	 * @author zzhanglin
	 */	
	public class Character extends Building
	{
		public static var astar:AStar = new AStar(MapGridDataModel.instance.astarGrid );
		
		protected var _bmpMC:BitmapMovieClip;
		protected var _currentActions:String ;
		protected var _roads:Array ; //路
		public var speed:Number = 6 ;
		public var nextPoint:Node ; //下一个坐标
		public var bornPoint:Point ; // 默认出生点位置
		protected var roadIndex:int =0 ;
		private var _firstMove:Boolean;
		
		public function Character(vo:BuildingVO)
		{
			super(vo);
			itemLayer.y = 20;
		}
		
		public function get currentActions():String{
			return  _currentActions;
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
		
		/* 创建人物动画 */
		protected function createCharacterSkin():void
		{
			//获取元件
			_skin = ResourceUtil.instance.getInstanceByClassName( baseBuildingVO.resId , baseBuildingVO.alias ) as MovieClip;
			if(_skin){
				_bmpMC = EffectManager.instance.createBmpAnimByMC( _skin );
				itemLayer.addChild(_bmpMC);
				this.gotoAndPlay(AvatarAction.IDLE);
				//设置偏移值
				var rect:Rectangle = _bmpMC.getBound();
				_bmpMC.x = rect.x ;
				_bmpMC.y = rect.y ;
			}
		}
		
		/**
		 * 移动到一个点 
		 * @param point
		 * @return 是否到达该点
		 */		
		protected function moveToPoint( point:Node):Boolean 
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
					var t:Number = getTimer();
					MapGridDataModel.instance.astarGrid.setStartNode( nodeX,nodeZ );
					MapGridDataModel.instance.astarGrid.setEndNode( endNodeX,endNodeZ );
					var result:Boolean ;
					if( this is Hero) {
						MapGridDataModel.instance.astarGrid.calculateLinks();
					}
					if( astar.findPath() ) 
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
					nodeX = endNodeX;
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
				if(!nextPoint){
					arrived();
				}
			}
		}
		
		/**
		 * 从路中取出一个点 
		 * @return 
		 */		
		protected function getNextPoint():Node
		{
			if(!roads) {
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
				return null ;
			}
		}
		
		/**
		 * 到达目的地了
		 * */
		protected function arrived():void{ }
		
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
			ResourceUtil.instance.removeEventListener( buildingVO.baseVO.resId , resLoadedHandler );
			ContainerUtil.removeChildren(itemLayer);
			createCharacterSkin();
		}
		
		/**
		 * 播放动作 
		 * @param action
		 */		
		public function gotoAndPlay( action:String ):void
		{
			if(_bmpMC){
				_currentActions = action ;
				_bmpMC.gotoAndPlay( action);
				var rect:Rectangle = _bmpMC.getBound();
				_bmpMC.x = rect.x ;
				_bmpMC.y = rect.y ;
			}
		}
		
		override public function update():void
		{
			if(_bmpMC){
				if(_bmpMC.update())
				{
					var rect:Rectangle = _bmpMC.getBound();
					_bmpMC.x = rect.x ;
					_bmpMC.y = rect.y ;
				}
			}
			if( roads && nextPoint ){
				move();
			}
		}
		
		
		/*返回一个可以走动的点 , radius为半径*/
		protected function getFreeRoad( radius:int = 8 ):Point{
			var p:Point ;
			var pos:Array =[] ;
			var newScene:IsoScene ;
			var currScene:IsoScene;
			for(var i:int = nodeX-radius ; i<nodeX+radius ; ++i){
				for(var j:int = nodeZ-radius ; j<nodeZ+radius ; ++j){
					if(i>1&& j>1&&i+1<=GameSetting.GRID_X&&j+1<=GameSetting.GRID_Z ){
						if( !(i==nodeX&&j==nodeZ) && MapGridDataModel.instance.astarGrid.getNode(i,j).walkable 
							&& MapGridDataModel.instance.buildingGrid.getNode(i,j).walkable )
						{
							newScene = GameWorld.instance.getBuildingScene(i,j) ;
							currScene = GameWorld.instance.getBuildingScene(nodeX,nodeZ) ;
							if(newScene && currScene &&newScene==currScene)	pos.push( new Point(i,j));
						}
					}
				}
			}
			if(pos.length>0){
				var len:int = pos.length-1 ;
				var index:int = Math.round(Math.random()*len);
				return pos[index] ;
			}
			return null ;
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