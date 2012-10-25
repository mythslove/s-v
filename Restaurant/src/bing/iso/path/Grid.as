package  bing.iso.path
{
	/**
	 * Holds a two-dimensional array of Nodes methods to manipulate them, start node and end node for finding a path.
	 */
	public class Grid
	{
		private var _startNode:Node;
		private var _endNode:Node;
		private var _nodes:Array;
		private var _numCols:int;
		private var _numRows:int;
		
		private var _type:int;
		
		private var _straightCost:Number = 1.0;
		private var _diagCost:Number = Math.SQRT2;
		
		/**
		 * Constructor.
		 */
		public function Grid(numCols:int, numRows:int)
		{
			_numCols = numCols;
			_numRows = numRows;
			_nodes = [];
			
			for(var i:int = 0; i < _numCols; i++)
			{
				_nodes[i] = [] ;
				for(var j:int = 0; j < _numRows; j++)
				{
					_nodes[i][j] = new Node(i, j);
				}
			}
		}
		
		
		////////////////////////////////////////
		// public methods
		////////////////////////////////////////
		
		/**
		 * 改变网格数组大小
		 * @param numCols
		 * @param numRows
		 */		
		public function changeSize(numCols:int , numRows:int ):void
		{
			var nodes:Array = [];
			for(var i:int = 0; i < numCols; i++)
			{
				nodes[i] = [];
				for(var j:int = 0; j < numRows; j++)
				{
					if(i<_numCols && j<_numCols){
						nodes[i][j] = _nodes[i][j];
					}else{
						nodes[i][j] = new Node(i, j);
					}
				}
			}
			_numCols = numCols;
			_numRows = numRows;
			_nodes = nodes;
		}
		
		/**
		 * Returns the node at the given coords.
		 * @param x The x coord.
		 * @param y The y coord.
		 */
		public function getNode(x:int, y:int):Node
		{
			return _nodes[x][y] as Node;
		}
		
		/**
		 * Sets the node at the given coords as the end node.
		 * @param x The x coord.
		 * @param y The y coord.
		 */
		public function setEndNode(x:int, y:int):void
		{
			_endNode = _nodes[x][y] as Node;
		}
		
		/**
		 * get nodes By Walkable
		 * @return Node Vecter Array
		 */		
		public function getNodesByWalkable( walkable:Boolean ):Vector.<Node>
		{
			var vec:Vector.<Node> = new Vector.<Node>();
			var node:Node ;
			for(var i:int = 0; i < _numCols; i++)
			{
				for(var j:int = 0; j < _numRows; j++)
				{
					node = this.getNode(i,j) ;
					if(node.walkable==walkable)
					{
						vec.push( node ) ;
					}
				}
			}
			return vec ;
		}
		
		
		/**
		 *
		 * @param	node
		 * @param	type	0八方向 1四方向 2跳棋
		 */
		private function initNodeLink(node:Node, type:int):void {
			var startX:int = Math.max(0, node.x - 1);
			var endX:int = Math.min(numCols - 1, node.x + 1);
			var startY:int = Math.max(0, node.y - 1);
			var endY:int = Math.min(numRows - 1, node.y + 1);
			node.links = [];
			for (var i:int = startX; i <= endX; ++i){
				for (var j:int = startY; j <= endY; ++j){
					var test:Node = getNode(i, j);
					if (test == node || !test.walkable){
						continue;
					}
					if (type != 2 && i != node.x && j != node.y){
						var test2:Node = getNode(node.x, j);
						if (!test2.walkable){
							continue;
						}
						test2 = getNode(i, node.y);
						if (!test2.walkable){
							continue;
						}
					}
					var cost:Number = _straightCost;
					if (!((node.x == test.x) || (node.y == test.y))){
						if (type == 1){
							continue;
						}
						if (type == 2 && (node.x - test.x) * (node.y - test.y) == 1){
							continue;
						}
						if (type == 2){
							cost = _straightCost;
						} else {
							cost = _diagCost;
						}
					}
					node.links.push(new Link(test, cost));
				}
			}
		}
		
		/**
		 * 判断是否在区域内 
		 * @param x
		 * @param y
		 * @return 
		 */		
		public function checkInGrid( x:int , y:int ):Boolean
		{
			if(x<0 || y<0 || x>=_numCols || y>=_numRows) return false;
			return true;
		}
		
		/**
		 * Sets the node at the given coords as the start node.
		 * @param x The x coord.
		 * @param y The y coord.
		 */
		public function setStartNode(x:int, y:int):void
		{
			_startNode = _nodes[x][y] as Node;
		}
		
		/**
		 * Sets the node at the given coords as walkable or not.
		 * @param x The x coord.
		 * @param y The y coord.
		 */
		public function setWalkable(x:int, y:int, value:Boolean):void
		{
			_nodes[x][y].walkable = value;
		}
		
		/**
		 *
		 * @param	type	0四方向 1八方向 2跳棋
		 */
		public function calculateLinks(type:int = 0):void {
			this._type = type;
			for (var i:int = 0; i < _numCols; ++i ){
				for (var j:int = 0; j < _numRows; ++j){
					initNodeLink(_nodes[i][j], type);
				}
			}
		}
		
		
		
		////////////////////////////////////////
		// getters / setters
		////////////////////////////////////////
		
		public function getType():int {
			return _type;
		}
		
		/**
		 * Returns the end node.
		 */
		public function get endNode():Node
		{
			return _endNode;
		}
		
		/**
		 * Returns the number of columns in the grid.
		 */
		public function get numCols():int
		{
			return _numCols;
		}
		
		/**
		 * Returns the number of rows in the grid.
		 */
		public function get numRows():int
		{
			return _numRows;
		}
		
		/**
		 * Returns the start node.
		 */
		public function get startNode():Node
		{
			return _startNode;
		}
		
		/**
		 *复制 
		 */		
		public function clone():Grid
		{
			var gird:Grid = new Grid( this._numCols  , this._numRows );
			for(var i:int = 0; i < _numCols; i++)
			{
				for(var j:int = 0; j < _numRows; j++)
				{
					gird.getNode(i,j).walkable = this.getNode(i,j).walkable;
				}
			}
			return gird;
		}
	}
}