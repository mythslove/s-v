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
		private var _openList:BinaryHeap = null ;
		private var _nowversion:int ;
		private static var _instance:AstarFindPathUtil = null;
		
		private var justMinFun:Function = function(x:Object, y:Object):Boolean {
			return x.F < y.F   ;
		};
		
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
			++_nowversion;
			initData() ;
			//计算终点（处理当用户 点击的地方不是碰撞块的时候）
			var tempEndPoint:Point = checkEndPoint(startPoint,endPoint);
			if(tempEndPoint==null){//没有终点的话
				return null;
			}
			var currentNode:Node = _map[startPoint.y][startPoint.x]; 
			currentNode.version = _nowversion;
			var endNode:Node = _map[endPoint.y][endPoint.x]; 
			if(currentNode==null || endNode ==null ){
				return null ;
			}
			_openList.insert(currentNode); 
			while(_openList.length>1 )
			{
				currentNode = _openList.pop() as Node ;
				currentNode.isInClose = true;
			
				//当前节点==目标节点
				if(currentNode.x==tempEndPoint.x && currentNode.y==tempEndPoint.y){
					return createPath(startPoint.x, startPoint.y,tempEndPoint.x , tempEndPoint.y );
				}
				if(currentNode.x==endPoint.x && currentNode.y==endPoint.y){
					return createPath(startPoint.x, startPoint.y,endPoint.x , endPoint.y ); 
				}
				
			
				var aroundNodes:Array = getAroundsNode(currentNode.x, currentNode.y);
				var len:int = aroundNodes.length ;
				var node:Node ;
				var g:int , h:int ,f:int ;
				for ( var i:int = 0 ; i< len ; ++i)
				{
					node = aroundNodes[i] ;
					g = this.getGValue(currentNode, node);
					h = this.getHValue( node,endNode);
					f = g+h ;
					if (node.version == _nowversion )	
					{
						if ( node.F > f) 
						{
							node.G = g;
							node.H = h;
							node.F = f;
							node.parentNode = currentNode;
						}
					}
					else
					{
						node.G = g;
						node.H = h;
						node.F =f;
						node.parentNode = currentNode;
						_openList.insert(node);
						node.version = _nowversion ;
					}
				}
			}
			return null;
		}
		

		private function initData():void{
			_openList = new BinaryHeap(justMinFun) ;
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
		
	
		private function createPath(xStart:int, yStart:int , endX:int , endY:int ):Array
		{
			var startNode:Node = _map[yStart][xStart] as Node ;
			var endNode:Node = _map[endY][endX] as Node ;
			var path:Array = [] ;
			var node:Node = endNode ;
			path.push(IsoMapHelp.getPixelPoint( _cellWidth , _cellHeight ,  node.x, node.y ) );
			while (node != startNode){
				node = node.parentNode;
				path.unshift(IsoMapHelp.getPixelPoint( _cellWidth , _cellHeight ,  node.x, node.y ) );
			}
			return path;
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
			if(!_map){
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
	public var isInClose:Boolean = false ;
	public var version:int ;

	public function Node( px:int , py:int ){
		x=px;
		y=py;
	}
	

	public function init():void{
		parentNode = null ;
		isInClose = false ;
		F=0;
		H=0;
		G=0;
	}
}









class BinaryHeap
{
	public var a:Array = [];
	public var justMinFun:Function = function(x:Object, y:Object):Boolean {
		return x < y  ;
	};
	
	public function BinaryHeap( justMinFun:Function=null ){
		a.push(-1);
		if( justMinFun!=null ){
			this.justMinFun = justMinFun ;
		}
	}
	
	public function get length():int{
		return a.length;
	}
	
	public function insert(value:Object):void {
		var p:int = a.length;
		a[p] = value;
		var pp:int = p >> 1;
		while (p > 1 && justMinFun(a[p], a[pp])){
			var temp:Object = a[p];
			a[p] = a[pp];
			a[pp] = temp;
			p = pp;
			pp = p >> 1;
		}
	}
	
	public function pop():Object {
		var min:Object = a[1];
		a[1] = a[a.length - 1];
		a.pop();
		var p:int = 1;
		var l:int = a.length;
		var sp1:int = p << 1;
		var sp2:int = sp1 + 1;
		while (sp1 < l){
			if (sp2 < l){
				var minp:int = justMinFun(a[sp2], a[sp1]) ? sp2 : sp1;
			} else {
				minp = sp1;
			}
			if (justMinFun(a[minp], a[p])){
				var temp:Object = a[p];
				a[p] = a[minp];
				a[minp] = temp;
				p = minp;
				sp1 = p << 1;
				sp2 = sp1 + 1;
			} else {
				break;
			}
		}
		return min;
	}
}