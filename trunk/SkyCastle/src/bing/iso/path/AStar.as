package bing.iso.path
{
	import flash.utils.getTimer;

	public class AStar
	{
		private var _open:BinaryHeap;
		private var _grid:Grid;
		private var _endNode:Node;
		private var _startNode:Node;
		private var _path:Array;
		public var heuristic:Function;
		private var _straightCost:Number = 1.0;
		private var _diagCost:Number = Math.SQRT2;
		private var nowversion:int = 1;
		
		public function AStar(grid:Grid){
			this._grid = grid;
			heuristic = euclidian2;
			
		}
		
		private function justMin(x:Object, y:Object):Boolean {
			return x.f < y.f;
		}
		
		public function findPath():Boolean {
			_open = new BinaryHeap(justMin);
			return search();
		}
		
		public function search():Boolean {
			++nowversion;
			_startNode = _grid.startNode;
			_endNode = _grid.endNode;
			_startNode.g = 0;
			
			var node:Node = _startNode;
			node.version = nowversion;
			while (node != _endNode){
				var len:int = node.links.length;
				for (var i:int = 0; i < len; ++i){
					var test:Node = node.links[i].node;
					var cost:Number = node.links[i].cost;
					var g:Number = node.g + cost;
					var h:Number = heuristic(test);
					var f:Number = g + h;
					if (test.version == nowversion){
						if (test.f > f){
							test.f = f;
							test.g = g;
							test.h = h;
							test.parent = node;
						}
					} else {
						test.f = f;
						test.g = g;
						test.h = h;
						test.parent = node;
						_open.ins(test);
						test.version = nowversion;
					}
					
				}
				if (_open.a.length == 1){
					return false;
				}
				node = _open.pop() as Node;
			}
			buildPath();
			return true;
		}
		
		private function buildPath():void {
			_path = [];
			var node:Node = _endNode;
			_path.push(node);
			while (node != _startNode){
				node = node.parent;
				_path.unshift(node);
			}
		}
		
		public function get path():Array {
			return _path;
		}
		
		public function manhattan(node:Node):Number {
			return Math.abs(node.x - _endNode.x) + Math.abs(node.y - _endNode.y);
		}
		
		public function manhattan2(node:Node):Number {
			var dx:Number = Math.abs(node.x - _endNode.x);
			var dy:Number = Math.abs(node.y - _endNode.y);
			return dx + dy + Math.abs(dx - dy) *0.001 ;
		}
		
		public function euclidian(node:Node):Number {
			var dx:Number = node.x - _endNode.x;
			var dy:Number = node.y - _endNode.y;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		private const TwoOneTwoZero:Number = 2 * Math.cos(Math.PI / 3);
		
		public function chineseCheckersEuclidian2(node:Node):Number {
			var y:int = node.y / TwoOneTwoZero;
			var x:int = node.x + node.y * 0.5  ;
			var dx:Number = x - _endNode.x -_endNode.y * 0.5 ;
			var dy:Number = y - _endNode.y / TwoOneTwoZero;
			return sqrt(dx * dx + dy * dy);
		}
		
		private function sqrt(x:Number):Number {
			return Math.sqrt(x);
		}
		
		public function euclidian2(node:Node):Number {
			var dx:Number = node.x - _endNode.x;
			var dy:Number = node.y - _endNode.y;
			return dx * dx + dy * dy;
		}
		
		public function diagonal(node:Node):Number {
			var dx:Number = Math.abs(node.x - _endNode.x);
			var dy:Number = Math.abs(node.y - _endNode.y);
			var diag:Number = Math.min(dx, dy);
			var straight:Number = dx + dy;
			return _diagCost * diag + _straightCost * (straight - 2 * diag);
		}
	}
}
