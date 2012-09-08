package local.util
{
	import local.map.item.Car;
	import local.map.item.Character;
	import local.map.item.MoveItem;

	/**
	 * 车和人的对象池 
	 * @author zhouzhanglin
	 */	
	public class ObjectPool
	{
		private static var _instance:ObjectPool;
		public static function get instance():ObjectPool
		{
			if(!_instance) _instance = new ObjectPool();
			return _instance; 
		}
		//=================================
		
		
		private var _objects:Array = [];
		
		private var carTypes:Array = ["RedCar","YellowCar"];
		private var characterTypes:Array = [ "Fairy" ];
		
		/**
		 * 获得车子 
		 * @return 
		 */		
		public function getCar():MoveItem
		{
			var len:int = _objects.length ;
			for( var i:int ; i<len ; ++i )
			{
				if(_objects[i] is Car ){
					var item:MoveItem = _objects.splice( i , 1 )[0] as MoveItem ;
					return  item ;
				}
			}
			var index:int= ( carTypes.length*Math.random() ) >>0 ;
			item = new Car( EmbedsManager.instance.getAnimResVOByName( carTypes[index])[0]  );
			return item ;
		}
		
		/**
		 * 获得 走路的人
		 * @return 
		 */		
		public function getCharacter():MoveItem
		{
			var len:int = _objects.length ;
			for( var i:int ; i<len ; ++i )
			{
				if(_objects[i] is Character ){
					var item:MoveItem = _objects.splice( i , 1 )[0] as MoveItem ;
					return  item ;
				}
			}
			var index:int= ( characterTypes.length*Math.random() ) >>0 ;
			item = new Character( EmbedsManager.instance.getAnimResVOByName( characterTypes[index])[0]  );
			return item ;
		}
		
		/**
		 * 将对象还原到对象池 
		 * @param item
		 */		
		public function addMoveItemToPool( item:MoveItem ):void
		{
			_objects.push( item );
		}
		
		/**
		 * 清除对象池 
		 */		
		public function clearPool():void
		{
			_objects = [];
		}
	}
}