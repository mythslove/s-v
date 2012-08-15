package game.utils
{
	
	import bing.tiled.IsoMapHelp;
	
	import flash.geom.Point;
	
	import game.global.GameData;
	
	/**
	 * A* 寻路 , 只寻当前屏幕的
	 * @author zhouzhanglin
	 * @date 2010/9/22
	 */	
	public class AstarFindPath2Util
	{
		//常量========================
		//横向移动一格的值
		private const COST_HORIZONTAL:int = 20;
		//竖向移动一格的值
		private const COST_VERTICAL:int = 5;
		//斜向移动的值
		private const COST_DIAGONAL :int  = 12;
		//============================
		private var _cellWidth:int=60; //矩形块的宽度
		private var _cellHeight:int=30; //矩形块的高度
		private var _xNum:int = 0; //地图矩形的横向块数
		private var _yNum:int = 0; //地图矩形的纵向块数
		private var _map:Array = null ;//存放所有的地图矩形方格
		private var _impactArray:Array = null ;//碰撞块数组
		private var _openList:Array = null ;//开放列表
		private var _closeList:Array = null ;//关闭列表
		private var _isFinded:Boolean = false ;//是否已经找到路径
		private static var _instance:AstarFindPath2Util = null; //当前对象
		/**
		 * 构造函数 
		 * @param tileWidth
		 * @param tileHeight
		 * @param xNum 地图矩形的横向块数
		 * @param yNum 地图矩形的纵向块数
		 * @param impactArray 碰撞块数组，行列的二维数组
		 */		
		public function AstarFindPath2Util(tileWidth:int , tileHeight:int  , xNum:int , yNum:int , impactArray:Array){
			this._cellWidth = tileWidth;
			this._cellHeight = tileHeight;
			this._xNum = xNum ;
			this._yNum = yNum ; 
			this._impactArray = impactArray ;
			
			AstarFindPath2Util._instance = this;
		}
		/**
		 * 获取寻路对象 
		 * @return 
		 */		
		public static function get instance():AstarFindPath2Util
		{
			return _instance;
		}
		
		/**
		 * 开始寻路 
		 * @param startPoint 开始点位置
		 * @param endPoint  结束点位置
		 * @return 寻路结果集合
		 */		
		public function searchPath(startPoint:Point , endPoint:Point  ):Array
		{
			initData() ;//初始化一些数据
			//计算终点（处理当用户 点击的地方不是碰撞块的时候）
			var tempEndPoint:Point = checkEndPoint(startPoint,endPoint);
			if(tempEndPoint==null){//没有终点的话
				return null;
			}
			var currentNode:Node = _map[startPoint.y+"-"+startPoint.x]; //开始节点
			var endNode:Node = _map[endPoint.y+"-"+endPoint.x]; //结束结点
			if(currentNode==null || endNode ==null ){
				return null ;
			}
			_openList.push(currentNode); //先在开启列表中放入一个节点
			while(_openList.length>0){
				//取出并删除开放列表第一个元素
				currentNode = _openList.shift();
				//加入到关闭列表
				currentNode.isInOpen = false;
				currentNode.isInClose = true;
				this._closeList.push(currentNode);	
				
				//当前节点==目标节点
				if(currentNode.x==tempEndPoint.x && currentNode.y==tempEndPoint.y){
					this._isFinded = true;	//能达到终点，找到路径
					break;
				}
				
				//当前节点==目标节点
				if(currentNode.x==endPoint.x && currentNode.y==endPoint.y){
					this._isFinded = true;	//能达到终点，找到路径
					break;
				}
				
				//取相邻八个方向的节点，去除不可通过和以在关闭列表中的节点
				var aroundNodes:Array = this.getAroundsNode(currentNode.x, currentNode.y);
				for each (var node:Node in aroundNodes) //检测相邻的八个方向的节点
				{
					//计算 G， H 值   
					var g:int = this.getGValue(currentNode, node);
					var h:int = this.getHValue( node,endNode);
					
					if (node.isInOpen)	//如果节点已在播放列表中
					{
						//如果该节点新的G值比原来的G值小,修改F,G值，设置该节点的父节点为当前节点
						if (g < node.G)
						{
							node.G = g;
							node.H = h;
							node.F = g + h;
							node.parentNode = currentNode;
							this.findAndSort(node);
						}
					}
					else //如果节点不在开放列表中
					{
						node.G = g;
						node.H = h;
						node.F = g + h;
						node.parentNode = currentNode;
						//插入开放列表中，并按照估价值排序							
						this.insertAndSort(node);
					}
				}
			}
			if (this._isFinded)	//找到路径
			{
				var path:Array = this.createPath(startPoint.x, startPoint.y);
				this.release(); 
				return path;
			}else{
				this.release();
				return null;
			}
		}
		
		/**
		 * 初始化一些数据 
		 *  目的是多次寻路时只需要重新实例化下面的数组即可
		 */		
		private function initData():void{
			_openList = [] ;
			_closeList = [] ;
			this.initMap()
		}
		
		/**
		 * 如果当前点击的对象是碰撞块，则设置到最近点
		 * @param startPoint 英雄所在位置
		 * @param endPoint 当前用户点击的点
		 * @return  最终点
		 */		
		private function checkEndPoint(startPoint:Point , endPoint:Point):Point{
			//如果点的地方不是碰撞块
			if(_impactArray[endPoint.y+"-"+endPoint.x]==false){
				return endPoint;
			}
			//如果点的地方是碰撞块
			var chaX:int = endPoint.x - startPoint.x ; //X之差
			var chaY:int = endPoint.y -startPoint.y ;//Y之差
			if(chaY>0){ //在下面
				for(var y:int  = endPoint.y -1 ; y>startPoint.y ; --y){
					if(chaX>0){ //在下右
						for(var x:int = endPoint.x-1 ; x>=startPoint.x ; --x ){
							if(_impactArray[y+"-"+x]==false){ //如果不是碰撞块
								return new Point(x,y);//返回此点
							}
						}
					}else  if(chaX<0){ //在下左
						for(x = endPoint.x+1 ; x<= startPoint.x ; ++x ){
							if(_impactArray[y+"-"+x]==false){ //如果不是碰撞块
								return new Point(x,y);//返回此点
							}
						}
					}else{ //正下面
						if(_impactArray[y+"-"+x]==false){ //如果不是碰撞块
							return new Point(x,y);//返回此点
						}
					}
				}
			}else if(chaY<0){ //在上面
				for( y  = endPoint.y+1 ; y<startPoint.y  ; ++y){
					if(chaX>0){ //在上右
						for(x = endPoint.x-1 ; x>=startPoint.x ; --x ){
							if(_impactArray[y+"-"+x]==false){ //如果不是碰撞块
								return new Point(x,y);//返回此点
							}
						}
					}else if(chaX<0){ //在上左
						for( x = endPoint.x+1 ; x<=startPoint.x ; ++x ){
							if(_impactArray[y+"-"+x]==false){ //如果不是碰撞块
								return new Point(x,y);//返回此点
							}
						}
					}else{ //正上中
						if(_impactArray[y+"-"+x]==false){ //如果不是碰撞块
							return new Point(x,y);//返回此点
						}
					}
				}
			}else{ //Y相等
				if(chaX>0){ //在右
					for(x = endPoint.x-1 ; x>startPoint.x ; --x ){
						if(_impactArray[y+"-"+x]==false){ //如果不是碰撞块
							return new Point(x,y);//返回此点
						}
					}
				}else if(chaX<0) { //在左 
					for( x = endPoint.x+1 ; x<startPoint.x ; ++x ){
						if(_impactArray[y+"-"+x]==false){ //如果不是碰撞块
							return new Point(x,y);//返回此点
						}
					}
				}else{ //相等情况
					if(_impactArray[y+"-"+x]==false){ //如果不是碰撞块
						return new Point(x,y);//返回此点
					}
				}
			}
			return null;
		}
		
		/**
		 * 生成路径数组
		 */
		private function createPath(xStart:int, yStart:int):Array
		{
			var path:Array = []; //实例化路径数组
			var node:Node = this._closeList.pop(); //删除最后一个，并返回此删除的值
			while (node.x != xStart || node.y != yStart)
			{
				path.unshift(IsoMapHelp.getPixelPoint( _cellWidth , _cellHeight ,  node.x, node.y ) ); 
				node = node.parentNode ;
			}
			path.unshift(IsoMapHelp.getPixelPoint( _cellWidth , _cellHeight ,  node.x, node.y ) );
			return path;
		}
		
		/**
		 * 删除列表中原来的node，并将node放到正确顺序
		 */
		private function findAndSort(node:Node):void
		{
			var listLength:int = this._openList.length;
			
			if (listLength < 1) return;
			for (var i:int=0; i<listLength; i++)
			{
				if (node.F <= this._openList[i].F)
				{
					this._openList.splice(i, 0, node); //插入此节点
				}
				if (node.x == this._openList[i].x && node.y == this._openList[i].y)
				{
					this._openList.splice(i, 1); //如果有此节点，就将此节点删除
				}
			}
		}
		
		/**
		 * 按由小到大顺序将节点插入到列表
		 */
		private function insertAndSort(node:Node):void
		{
			node.isInOpen= true; //设置为在开启列表中
			var len:int = this._openList.length ;
			if (len == 0)
			{
				this._openList.push(node);
				
			} else{
				for (var i:int=0; i<len ; i++)
				{
					if (node.F <= this._openList[i].F) //根据F值大小来排序并插入Node, F值小就放前面
					{
						this._openList.splice(i, 0, node);
						return;
					}
				}
				this._openList.push(node); //防止其他意外情况下没有将节点放入开启列表中
			}
			
		}
		
		/**
		 * 得到周围八方向节点
		 */
		private function getAroundsNode(x:int, y:int):Array
		{
			var aroundNodes:Array = [] ;
			
			var checkX:int;
			var checkY:int;
			/**
			 * 菱形组合的地图八方向与正常不同
			 */
			//左
			checkX = x-1
			checkY = y;
			if (isWalkable(checkX, checkY) && !this._map[checkY+"-"+checkX].isInClose)
			{
				//trace("左:::"+checkY+"##"+checkX);
				aroundNodes.push(this._map[checkY+"-"+checkX]);
			}
			//右
			checkX = x+1;
			checkY = y;
			if (isWalkable(checkX, checkY) && !this._map[checkY+"-"+checkX].isInClose)
			{
				//trace("右:::"+checkY+"##"+checkX);
				aroundNodes.push(this._map[checkY+"-"+checkX]);
			}
			//上
			checkX = x;
			checkY = y-2;
			if (isWalkable(checkX, checkY) && !this._map[checkY+"-"+checkX].isInClose)
			{
				//trace("上:::"+checkY+"##"+checkX);
				aroundNodes.push(this._map[checkY+"-"+checkX]);
			}
			//下
			checkX = x;
			checkY = y+2;
			if (isWalkable(checkX, checkY) && !this._map[checkY+"-"+checkX].isInClose)
			{
				//trace("下:::"+checkY+"##"+checkX);
				aroundNodes.push(this._map[checkY+"-"+checkX]);
			}
			//左上
			checkX = x-1+(y&1);
			checkY = y-1;
			if (isWalkable(checkX, checkY) && !this._map[checkY+"-"+checkX].isInClose)
			{
				//trace("左上:::"+checkY+"##"+checkX);
				aroundNodes.push(this._map[checkY+"-"+checkX]);
			}
			//左下
			checkX = x-1+(y&1);
			checkY = y+1;
			if (isWalkable(checkX, checkY) && !this._map[checkY+"-"+checkX].isInClose)
			{
				//trace("左下:::"+checkY+"##"+checkX);
				aroundNodes.push(this._map[checkY+"-"+checkX]);
			}
			//右上
			checkX = x+(y&1);
			checkY = y-1;
			if (isWalkable(checkX, checkY) && !this._map[checkY+"-"+checkX].isInClose)
			{
				//trace("右上:::"+checkY+"##"+checkX);
				aroundNodes.push(this._map[checkY+"-"+checkX]);
			}
			//右下
			checkX = x+(y&1);
			checkY = y+1;
			if (isWalkable(checkX, checkY) && !this._map[checkY+"-"+checkX].isInClose)
			{
				//trace("右下:::"+checkY+"##"+checkX);
				aroundNodes.push(this._map[checkY+"-"+checkX]);
			}
			
			return aroundNodes;
		}
		
		/**
		 * 计算G值（此节点与周围八个点的距离）
		 */
		private function getGValue(currentNode:Node, node:Node):int
		{
			var g:int = 0; 
			if (currentNode.y == node.y)			// 横向  左右
			{
				g = currentNode.G + this.COST_HORIZONTAL;
			}
			else if (currentNode.y+2 == node.y || currentNode.y-2 == node.y)// 竖向  上下
			{
				g = currentNode.G + this.COST_VERTICAL * 2;
			}
			else	// 斜向  左上 左下 右上 右下
			{
				g = currentNode.G + this.COST_DIAGONAL;
			}
			
			return g;
		}
		
		/**
		 * 计算H值（此节点到终点的距离）
		 */
		private function getHValue( node:Node , endNode:Node):int
		{
			var dx:int;
			var dy:int;
			//节点到0，0点的x轴距离
			var dxNodeTo0:int = node.x * this.COST_HORIZONTAL + (node.y&1) * this.COST_HORIZONTAL*0.5;
			//终止节点到0，0点的x轴距离
			var dxEndNodeTo0:int = endNode.x * this.COST_HORIZONTAL + (endNode.y&1) * this.COST_HORIZONTAL*0.5; 
			dx = Math.abs(dxEndNodeTo0 - dxNodeTo0);
			dy = Math.abs(endNode.y - node.y) * this.COST_VERTICAL;
			return dx + dy;
		}
		
		/**
		 * 检查点在地图上是否可通过
		 */
		private function isWalkable(x:int, y:int):Boolean
		{
			//判断是否超出边界了
			if(x<_lt_ScreenTilePoint.x||y<_lt_ScreenTilePoint.y||x>=_rb_ScreenTilePoint.x ||y>=_rb_ScreenTilePoint.y){
				return false;
			}
			//判断是否为碰撞块
			if(this._impactArray[y+"-"+x]==true){
				return false;
			}
			return true;
		}
		
		private var _lt_ScreenTilePoint:Point = null ;
		private var _rb_ScreenTilePoint:Point = null ;
		
		/**
		 * 初始化地图数组 
		 */		
		private function initMap():void{
			//屏幕偏移
			var offsetX:int = GameData.screenRect.x ;
			var offsetY:int = GameData.screenRect.y ;
			//左上角和右下角的mqs
			_lt_ScreenTilePoint   = IsoMapHelp.getCellPoint( _cellWidth , _cellHeight , offsetX , offsetY ) ;
			_rb_ScreenTilePoint = IsoMapHelp.getCellPoint(_cellWidth , _cellHeight ,  GameData.screenRect.width+offsetX+_cellWidth , GameData.screenRect.height+offsetY+_cellHeight) ;
			
			//初始化地图数据
			_map = [] ;
			//循环一行
			for(var yy:int = _lt_ScreenTilePoint.y ; yy<_rb_ScreenTilePoint.y ; ++yy ){
				//循环一列
				for(var xx:int = _lt_ScreenTilePoint.x ; xx< _rb_ScreenTilePoint.x ; ++xx ){
					_map[yy+"-"+xx] = new Node(xx,yy);
				}
			}
		}
		/**
		 * 销毁数组
		 * @param gc 是否彻底销毁
		 */
		public function release( gc:Boolean= false ):void
		{
			var len:int = _closeList.length ;
			for(var i:int = 0 ; i<len  ; ++i ){
				_closeList[i] .release() ;
				_closeList[i] = null ;
			}
			this._closeList.length = 0 ;
			this._closeList = null;
			
			len = _openList.length ;
			for(i = 0 ; i< len ; ++i ){
				_openList[i] .release() ;
				_openList[i] = null ;
			}
			this._openList.length = 0 ;
			this._openList = null;
			
			this._isFinded = false;
			if( !gc ){
				initMap();
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
	public var parentNode:Node = null; //父结点
	public var isInOpen:Boolean = false;//是否在开启列表中
	public var isInClose:Boolean = false ;//是否在关闭列表中
	
	/**
	 * 一个节点 
	 * @param x    tileX
	 * @param y		tileY
	 */	
	public function Node(x:int , y:int ){
		this.x=x;
		this.y=y;
	}
	
	/**
	 * 重新初始化
	 */	
	public function init():void{
		parentNode = null ;
		isInOpen = false ;
		isInClose = false ;
		F=0;
		H=0;
		G=0;
	}
	
	/**
	 * 释放资源
	 */	
	public function release():void {
		this.parentNode = null ;
	}
}