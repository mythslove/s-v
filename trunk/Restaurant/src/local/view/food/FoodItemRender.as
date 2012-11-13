package local.view.food
{
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	
	public class FoodItemRender extends FeathersControl implements IListItemRenderer
	{
		private var _data:Object ;
		public function get data():Object{ return _data ; }
		public function set data(value:Object):void{
			_data = value;
		}
		private var _index:int ;
		public function get index():int{ return _index ; };
		public function set index(value:int):void{ _index = value ;}
		private var _owner:List ;
		public function get owner():List{ return _owner ;}
		public function set owner(value:List):void{ _owner = value ;}
		private var _isSelected:Boolean 
		public function get isSelected():Boolean{ return _isSelected ;}
		public function set isSelected(value:Boolean):void{ _isSelected = value ;}
		
		
		
		public function FoodItemRender()
		{
			super();
		}
	}
}