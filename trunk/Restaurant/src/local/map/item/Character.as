package local.map.item
{
	import bing.iso.path.AStar;
	import bing.iso.path.Node;
	import bing.starling.component.FrameSprite;
	import bing.utils.MathUtil;
	
	import local.comm.GameSetting;
	import local.model.MapGridDataModel;
	import local.vo.ItemVO;
	
	import starling.display.Quad;
	
	public class Character extends BaseItem
	{
		public static const ACTION_STAND:String ="stand";
		public static const ACTION_WALK:String = "walk";
		public static const ACTION_SIT:String = "sit";
		public static const ACTION_EAT:String = "eat";
		//=========================================
		private var _frameSprite:FrameSprite ;
		private var _action:String ;
		private var _firstMove:Boolean;
		
		public var speed:Number = 6 ;
		public var nextPoint:Node ; //下一个坐标
		
		protected var _roads:Array ; //路
		protected var roadIndex:int =0 ;
		public function set roads( value:Array ):void {
			_roads = value ;
			if(value==null) play(ACTION_STAND) ;
		}
		public function get roads():Array{ return _roads ;}
		
		private var _step:int ;
		
		public function Character(itemVO:ItemVO)
		{
			super(itemVO);
		}
		
		override public function showUI():void
		{
			var quad:Quad = new Quad(10,10,0xffcc00);
			addChild( quad);
		}
		
		/**
		 * 移动到一个点 
		 * @param point
		 * @return 是否到达该点
		 */		
		protected function moveToPoint( point:Node):Boolean 
		{
			var distance:Number = MathUtil.distance(position.x , position.z , point.x,point.y );
			if(distance < speed){
				this.sort();
				return true;
			}
			if(_action!=ACTION_WALK){
				play(ACTION_WALK);
			}
			var moveNum:Number = distance/this.speed ;
			this.setPositionXYZ( position.x+(point.x - position.x)/moveNum , 0 ,position.z+(point.y - position.z)/moveNum);
			if(_firstMove){
				this.sort();
				_firstMove = false ;
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
			if(!roads) return null ;
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
					this.setPositionXYZ( nextPoint.x , 0 ,nextPoint.y);
				}
				roads = null ;
				nextPoint = null ;
				play(ACTION_STAND) ;
				return null ;
			}
		}
		
		/**
		 * 寻路移动 
		 * @param endNodeX
		 * @param endNodeZ
		 * @return true表示有路径，false为没有路
		 */		
		public function searchToRun( endNodeX:int , endNodeZ:int):Boolean
		{
			var astar:AStar = MapGridDataModel.instance.astar ;
			
			if(MapGridDataModel.instance..getNode(endNodeX,endNodeZ).walkable )
			{
				if(MapGridDataModel.instance.gameGridData.getNode(nodeX,nodeZ).walkable)
				{
					MapGridDataModel.instance.gameGridData.setStartNode( nodeX,nodeZ );
					MapGridDataModel.instance.gameGridData.setEndNode( endNodeX,endNodeZ );
					var result:Boolean ;
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
				}else if(_action==ACTION_STAND){
					nodeX = endNodeX;
					nodeZ = endNodeZ;
					play(ACTION_STAND);
					sort();
				}
			}
			return false;
		}
		
		/**
		 * 到达目的地了
		 * */
		protected function arrived():void
		{
			
		}
		/**
		 * 停止移动 
		 */		
		public function stopMove():void 
		{
			roads = null ;
			play(ACTION_STAND) ;
		}
		
		public function play( action:String ):void
		{
			
			this._action = action ;
		}
		
		override public function advanceTime(passedTime:Number):void
		{
			super.advanceTime(passedTime);
			if( roads && nextPoint ){
				move();
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			_frameSprite.destroy();
			_frameSprite = null ;
			_roads = null ;
			nextPoint = null ;
			_step = 0;
		}
	}
}