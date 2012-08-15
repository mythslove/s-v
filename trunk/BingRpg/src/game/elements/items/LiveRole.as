package game.elements.items
{
	import bing.tiled.IsoMapHelp;
	import bing.utils.MathUtil;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import game.elements.cell.AniComponent;
	import game.elements.items.interfaces.IMoveable;
	import game.global.Constants;
	import game.mvc.model.AniBaseModel;
	import game.mvc.model.MapDataModel;
	import game.mvc.model.vo.AniBaseVO;
	import game.mvc.model.vo.MapVO;
	import game.utils.AstarFindPath2Util;
	import game.utils.AstarFindPathUtil;
	import game.utils.PathOptimizer;
	
	import org.blch.findPath.NavMesh;
	import org.blch.geom.Vector2f;

	/**
	 * 可以在地图上跑动的角色 
	 * @author zhouzhanglin
	 */
	public class LiveRole extends StandRole implements IMoveable
	{
		public var speed:Number = 5 ;
		public var nextPoint:Point ; //下一个坐标
		public var roads:Array ; //路
		protected var roadIndex:int =0 ;
		private var _runResLoaded:Boolean = false ; //跑的资源是否都下载完成
		public var runAniBitmap:Dictionary ; //跑的动画
		
		public function LiveRole(itemId:int, name:String )
		{
			super(itemId,name);
		}
		
		override protected function init():void
		{
			super.init();
			createRunAnimation();
		}
		
		/**
		 * 创建跑动的动画组件 
		 */		
		protected function createRunAnimation():void
		{
			var aniBaseVO:AniBaseVO ;
			runAniBitmap = new Dictionary(false);
			var aniCom:AniComponent ;
			for( var i:int = 0 ; i<totalDirection ; i++)
			{
				aniBaseVO = AniBaseModel.instance.getAniBaseByName( itemVO.runAniName+itemVO.totalDirection[i] );
				aniCom = new AniComponent(aniBaseVO);
				runAniBitmap[aniBaseVO.name] = aniCom ;
			}
		}
		
		override public function update():void
		{
			if(nextPoint ==null || roads==null  || roads.length==0 ){
				actionName = "stand" ;
			}else{
				actionName = "run";
			}
			if(actionName=="stand"){
				stand();
			}else if(actionName=="run"){
				move();
			}
		}
		
		/**
		 * 判断跑动的资源是否下载完成 
		 * @return 
		 */		
		public function get runResLoaded():Boolean
		{
			if(!_runResLoaded){
				var temp:Boolean=true ;
				for each( var component:AniComponent in runAniBitmap)
				{
					if(!component.aniBitmap){
						temp = false ;
						break ;
					}
				}
				_runResLoaded = temp ;
			}
			return _runResLoaded;
		}
		
		/**
		 * 不断移动 
		 */		
		public function move():void
		{
			if(runResLoaded){
				currentAniComponent = runAniBitmap[ itemVO.runAniName+direction];
				updateAnimation();
			}
			if( moveToPoint(nextPoint) ){
				nextPoint = getNextPoint() ; //取下一个点
			}
			this.actionName="run";
			checkOnMask();
		}
		
		/**
		 * 移动到一个点 
		 * @param point
		 * @return 是否到达该点
		 */		
		public function moveToPoint( point:Point):Boolean 
		{
			var distance:Number = MathUtil.distance(x,y,point.x,point.y );
			if(distance < speed){
				return true;
			}
			setCurrentForward(point,totalDirection);
			var moveNum:Number = distance/this.speed ;
			this.x += ( (point.x - x)/moveNum)>>0 ;
			this.y += ( (point.y - y)/moveNum)>>0 ;
			
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
		 * 寻路并移动 
		 * @param px
		 * @param py
		 * @return 是否有路径
		 */		
		public function findAndMove( px:Number,py:Number ):Boolean 
		{
			var b:Boolean = false ;
			var roadsArray:Array ;
			if(MapDataModel.instance.serachRoadType==Constants.SEARCH_ROAD_TYPE_MESH){
				var nav:NavMesh = new NavMesh(MapDataModel.instance.cellV) ;
				roadsArray = nav.findPath( new Vector2f(this.x,this.y),new Vector2f(px,py));
			}
			else	
			{
				var mapVO:MapVO = MapDataModel.instance.currentMapVO ;
				var endPoint:Point = IsoMapHelp.getCellPoint( mapVO.tileWidth,mapVO.tileHeight,px,py);
				if(MapDataModel.instance.serachRoadType==Constants.SEARCH_ROAD_TYPE_ASTAR1){
					roadsArray = AstarFindPath2Util.instance.searchPath(tilePoint,endPoint) ;
				}else if(MapDataModel.instance.serachRoadType==Constants.SEARCH_ROAD_TYPE_ASTAR)	{
					roadsArray = AstarFindPathUtil.instance.searchPath(tilePoint,endPoint) ;
				}
				if(roadsArray){
					roadsArray = PathOptimizer.short( roadsArray );
				}
			}
			if(roadsArray && roadsArray.length>1){
				this.roads = roadsArray ;
				roadIndex = 0 ;
				this.getNextPoint();
				nextPoint = this.getNextPoint();
				b = true ;
				this.actionName="run"; //截断其他动作
			}
			return b ;
		}
		
		/**
		 * 停止移动 
		 */		
		public function stopMove():void 
		{
			roads = null ;
		}
		
		/**
		 * 从路中取出一个点 
		 * @return 
		 */		
		protected function getNextPoint():Point
		{
			var temp:Object = this.roads[roadIndex];
			roadIndex++;
			
			if(temp is Point) return temp as Point;
			if( temp is Vector2f) return (temp as Vector2f).toPoint() ;
			return null ;
		}
		
		override public function dispose():void
		{
			clearAniBitmap(runAniBitmap);
			runAniBitmap = null ;
			roads = null ;
			nextPoint = null ;
			super.dispose();
		}
		
	}
}