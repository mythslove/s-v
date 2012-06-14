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
		
		/**
		 * Constructor.
		 */
		public function Grid(numCols:int, numRows:int)
		{
			_numCols = numCols;
			_numRows = numRows;
			_nodes = new Array();
			
			for(var i:int = 0; i < _numCols; i++)
			{
				_nodes[i] = new Array();
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
		
		
		
		////////////////////////////////////////
		// getters / setters
		////////////////////////////////////////
		
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