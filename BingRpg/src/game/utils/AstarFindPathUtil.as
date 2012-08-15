package game.utils
{
	
	import bing.tiled.IsoMapHelp;
	
	import flash.geom.Point;
	
	/**
	 * A* 
	 * @author zhouzhanglin
	 * @date 2010/9/22
	 */	
	public class AstarFindPathUtil{
		//const========================
	
		private const COST_HORIZONTAL:int = 20;
		
		private const COST_VERTICAL:int = 5;
		
		private const COST_DIAGONAL :int  = 12;
		//============================
		private var _cellWidth:int=60; 
		private var _cellHeight:int=30; 
		private var _xNum:int = 0; 
		private var _yNum:int = 0; 
		private var _map:Array = null ;
		private var _impactArray:Array = null ;
		private var _openList:Array = null ;
		private var _closeList:Array = null ;
		private var _isFinded:Boolean = false ;
		private static var _instance:AstarFindPathUtil = null;
		/**
		 *
		 * @param tileWidth
		 * @param tileHeight
		 * @param xNum 
		 * @param yNum
		 * @param impactArray 
		 */		
		public function AstarFindPathUtil(tileWidth:int , tileHeight:int  , xNum:int , yNum:int , impactArray:Array){
			this._cellWidth = tileWidth;
			this._cellHeight = tileHeight;
			this._xNum = xNum ;
			this._yNum = yNum ; 
			this._impactArray = impactArray ;
			initMap();
			
			AstarFindPathUtil._instance = this;
		}

		public static function get instance():AstarFindPathUtil
		{
			return _instance;
		}
		

		public function searchPath(startPoint:Point , endPoint:Point  ):Array{
			initData() ;
			//计算终点（处理当用户 点击的地方不是碰撞块的时候）
			var tempEndPoint:Point = checkEndPoint(startPoint,endPoint);
			if(tempEndPoint==null){//没有终点的话
				return null;
			}
			var currentNode:Node = _map[startPoint.y][startPoint.x]; 
			var endNode:Node = _map[endPoint.y][endPoint.x]; 
			if(currentNode==null || endNode ==null ){
				return null ;
			}
			_openList.push(currentNode); 
			while(_openList.length>0){
				
				currentNode = _openList.shift();
			
				currentNode.isInOpen = false;
				currentNode.isInClose = true;
				_closeList.push(currentNode);	
			
				//当前节点==目标节点
				if(currentNode.x==tempEndPoint.x && currentNode.y==tempEndPoint.y){
					_isFinded = true;	//能达到终点，找到路径
					break;
				}
	
				if(currentNode.x==endPoint.x && currentNode.y==endPoint.y){
					_isFinded = true ;
					break;
				}
				
			
				var aroundNodes:Array = getAroundsNode(currentNode.x, currentNode.y);
				var len:int = aroundNodes.length ;
				var node:Node ;
				var g:int , h:int ;
				for ( var i:int = 0 ; i< len ; ++i)
				{
					node = aroundNodes[i] ;
					g = this.getGValue(currentNode, node);
					h = this.getHValue( node,endNode);
					
					if (node.isInOpen)	
					{
						if (g < node.G)
						{
							node.G = g;
							node.H = h;
							node.F = g + h;
							node.parentNode = currentNode;
							findAndSort(node);
						}
					}
					else
					{
						node.G = g;
						node.H = h;
						node.F = g + h;
						node.parentNode = currentNode;
						insertAndSort(node);
					}
				}
			}
			if (this._isFinded)	
			{
				var path:Array = createPath(startPoint.x, startPoint.y);
				this.release(); 
				return path;
			}else{
				this.release();
				return null;
			}
		}
		

		private function initData():void{
			_openList = [];
			_closeList = [];
			initMap();
		}
		
	
		private function checkEndPoint(startPoint:Point , endPoint:Point):Point{
			if(_impactArray[endPoint.y+"-"+endPoint.x]==false){
				return endPoint;
			}
			var chaX:int = endPoint.x - startPoint.x ; 
			var chaY:int = endPoint.y -startPoint.y ;
			if(chaY>0){ 
				for(var y:int  = endPoint.y-1 ; y>startPoint.y ; --y){
					if(chaX>0){ 
						for(var x:int = endPoint.x-1 ; x>=startPoint.x ; --x ){
							if(_impactArray[y+"-"+x]==false){ 
								return new Point(x,y);
							}
						}
					}else  if(chaX<0){ 
						for(x = endPoint.x+1 ; x<= startPoint.x ; ++x ){
							if(_impactArray[y+"-"+x]==false){ 
								return new Point(x,y);
							}
						}
					}else{
						if(_impactArray[y+"-"+x]==false){
							return new Point(x,y);
						}
					}
				}
			}else if(chaY<0){ 
				for( y  = endPoint.y+1 ; y<startPoint.y ; ++y){
					if(chaX>0){ 
						for(x = endPoint.x-1 ; x>=startPoint.x ; --x ){
							if(_impactArray[y+"-"+x]==false){ 
								return new Point(x,y);
							}
						}
					}else if(chaX<0){
						for( x = endPoint.x+1 ; x<=startPoint.x ; ++x ){
							if(_impactArray[y+"-"+x]==false){ 
								return new Point(x,y);
							}
						}
					}else{
						if(_impactArray[y+"-"+x]==false){ 
							return new Point(x,y);
						}
					}
				}
			}else{ 
				if(chaX>0){ 
					for(x = endPoint.x-1 ; x>startPoint.x ; --x ){
						if(_impactArray[y+"-"+x]==false){ 
							return new Point(x,y);
						}
					}
				}else if(chaX<0) {
					for( x = endPoint.x+1 ; x<startPoint.x ; ++x ){
						if(_impactArray[y+"-"+x]==false){ 
							return new Point(x,y);
						}
					}
				}else{
					if(_impactArray[y+"-"+x]==false){ 
						return new Point(x,y);
					}
				}
			}
			return null;
		}
		
	
		private function createPath(xStart:int, yStart:int):Array
		{
			var path:Array = [] ;
			var node:Node = _closeList.pop();
			while (node.x != xStart || node.y != yStart)
			{
				path.unshift(IsoMapHelp.getPixelPoint( _cellWidth , _cellHeight ,  node.x, node.y ) ); 
				node = node.parentNode ;
			}
			path.unshift(IsoMapHelp.getPixelPoint( _cellWidth , _cellHeight ,  node.x, node.y ) );
			return path;
		}
		
	
		private function findAndSort(node:Node):void
		{
			var listLength:int =  _openList.length;
			
			if (listLength < 1) return;
			for (var i:int=0; i<listLength; ++i )
			{
				if (node.F <=  _openList[i].F)
				{
					this._openList.splice(i, 0, node); 
				}
				if (node.x == _openList[i].x && node.y == _openList[i].y)
				{
					this._openList.splice(i, 1); 
				}
			}
		}
		

		private function insertAndSort(node:Node):void
		{
			node.isInOpen= true;
			var len:int =  _openList.length ;
			if (len == 0)
			{
				this._openList.push(node);
				
			} else{
				for (var i:int=0; i<len ; ++i)
				{
					if (node.F <=  _openList[i].F) 
					{
						this._openList.splice(i, 0, node);
						return;
					}
				}
				this._openList.push(node) ;
			}
			
		}
		

		private function getAroundsNode(x:int, y:int):Array
		{
			var aroundNodes:Array = [];
			
			var checkX:int;
			var checkY:int;
	
		
			checkX = x-1
			checkY = y;
			if (isWalkable(checkX, checkY) && ! _map[checkY][checkX].isInClose)
			{
				aroundNodes.push( _map[checkY][checkX]);
			}
		
			checkX = x+1;
			checkY = y;
			if (isWalkable(checkX, checkY) && ! _map[checkY][checkX].isInClose)
			{
				aroundNodes.push( _map[checkY][checkX]);
			}
		
			checkX = x;
			checkY = y-2;
			if (isWalkable(checkX, checkY) && ! _map[checkY][checkX].isInClose)
			{
				aroundNodes.push( _map[checkY][checkX]);
			}
			
			checkX = x;
			checkY = y+2;
			if (isWalkable(checkX, checkY) && ! _map[checkY][checkX].isInClose)
			{
				//trace("下:::"+checkY+"##"+checkX);
				aroundNodes.push( _map[checkY][checkX]);
			}
		
			checkX = x-1+(y&1);
			checkY = y-1;
			if (isWalkable(checkX, checkY) && ! _map[checkY][checkX].isInClose)
			{
				aroundNodes.push( _map[checkY][checkX]);
			}
		
			checkX = x-1+(y&1);
			checkY = y+1;
			if (isWalkable(checkX, checkY) && !_map[checkY][checkX].isInClose)
			{
				aroundNodes.push(_map[checkY][checkX]);
			}
		
			checkX = x+(y&1);
			checkY = y-1;
			if (isWalkable(checkX, checkY) && !_map[checkY][checkX].isInClose)
			{
				aroundNodes.push(_map[checkY][checkX]);
			}
			
			checkX = x+(y&1);
			checkY = y+1;
			if (isWalkable(checkX, checkY) && !_map[checkY][checkX].isInClose)
			{
				aroundNodes.push(_map[checkY][checkX]);
			}
			
			return aroundNodes;
		}
		
	
		private function getGValue(currentNode:Node, node:Node):int
		{
			var g:int = 0; 
			if (currentNode.y == node.y)			
			{
				g = currentNode.G + COST_HORIZONTAL;
			}
			else if (currentNode.y+2 == node.y || currentNode.y-2 == node.y)
			{
				g = currentNode.G + COST_VERTICAL * 2;
			}
			else					
			{
				g = currentNode.G + COST_DIAGONAL;
			}
			
			return g;
		}
		

		private function getHValue( node:Node , endNode:Node):int
		{
			var dx:int;
			var dy:int;
		
			var dxNodeTo0:int = node.x * COST_HORIZONTAL + (node.y&1) * COST_HORIZONTAL*0.5;
			
			var dxEndNodeTo0:int = endNode.x * COST_HORIZONTAL + (endNode.y&1) * COST_HORIZONTAL*0.5; 
			dx = Math.abs(dxEndNodeTo0 - dxNodeTo0);
			dy = Math.abs(endNode.y - node.y) * COST_VERTICAL;
			return dx + dy;
		}
		
	
		private function isWalkable(x:int, y:int):Boolean
		{
			
			if(x<0||y<0||x>=_xNum ||y>=_yNum*2-1){
				return false;
			}
		
			if(_impactArray[y+"-"+x]==true){
				return false;
			}
			return true;
		}
		
	
		private function initMap():void{
			var len:int =_yNum*2-1 ;
			if(_map!=null){
			
				for( yy = 0 ; yy<len ; ++yy ){
					
					for( xx = 0 ; xx<_xNum ; ++xx ){
						_map[yy][xx].init() ;
					}
				}
			}else{
				_map = [];
				
				for(var yy:int = 0 ; yy<len ; ++yy ){
					_map[yy] = [];
				
					for(var xx:int = 0 ; xx<_xNum ; ++xx ){
						_map[yy][xx] = new Node(xx,yy);
					}
				}
			}
		}

		public function release():void
		{
			var len:int =  _closeList.length ;
			for(var i:int = 0 ; i<len ; ++i ){
				_closeList[i] .release() ;
				_closeList[i] = null ;
			}
			_closeList.length = 0 ;
			_closeList = null;
			
			len =  _openList.length ;
			for(i = 0 ; i<len ; ++i ){
				_openList[i] .release() ;
				_openList[i] = null ;
			}
			_openList.length = 0 ;
			_openList = null;
			
			_isFinded = false;
		}
	}
}
//=========================
class Node{
	public var F:int = 0;
	public var G:int = 0;
	public var H:int = 0;
	public var x:int = 0;
	public var y:int = 0;
	public var parentNode:Node = null; 
	public var isInOpen:Boolean = false;
	public var isInClose:Boolean = false ;

	public function Node( px:int , py:int ){
		x=px;
		y=py;
	}
	

	public function init():void{
		parentNode = null ;
		isInOpen = false ;
		isInClose = false ;
		F=0;
		H=0;
		G=0;
	}
	
	public function release():void {
		parentNode = null ;
	}
}