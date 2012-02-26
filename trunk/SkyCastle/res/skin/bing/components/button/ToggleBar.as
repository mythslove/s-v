package bing.components.button
{
	import bing.components.BingComponent;
	import bing.components.events.ToggleItemEvent;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	/**
	 * 点击某一个按钮 ,通过selectedName来查看
	 */	
	[Event(name="eventItemSelected",type="bing.components.events.ToggleItemEvent")]
	
	public class ToggleBar extends BingComponent
	{
		private var _toggleButtons:Vector.<BaseToggleButton> ;
		private var _selectedName:String ="";
		
		public function ToggleBar()
		{
			super();
		}
		
		public function get selectedName():String
		{
			return _selectedName;
		}

		public function set selectedName(value:String):void
		{
			_selectedName = value;
			for each(var btn:BaseToggleButton in _toggleButtons )
			{
				if(btn.name==value)
				{
					btn.selected = true ;
					
					var evt:ToggleItemEvent = new ToggleItemEvent( ToggleItemEvent.EVENT_ITEM_SELECTED );
					evt.selectedName = btn.name ;
					this.dispatchEvent( evt );
					
				}else {
					btn.selected = false ;
				}
			}
		}

		override protected function addedToStage():void 
		{
			_toggleButtons = new Vector.<BaseToggleButton> ;
			var obj:DisplayObject ;
			var btn:BaseToggleButton ;
			const LEN:int = this.numChildren ;
			for( var i:int = 0 ; i < LEN ; i++){
				obj = this.getChildAt(i);
				if(obj is BaseToggleButton)
				{
					btn = obj as BaseToggleButton ;
					btn.addEventListener(MouseEvent.CLICK , btnClickHandler , false ,0 , true );
					_toggleButtons.push( btn );
				}
			}
		}
		
		private function btnClickHandler( event:MouseEvent):void 
		{
			btn = event.target as BaseToggleButton ;
			if(btn){
				_selectedName = btn.name ;
				for each(var btn:BaseToggleButton in _toggleButtons )	{
					btn.selected = false ;
				}
				
				var evt:ToggleItemEvent = new ToggleItemEvent( ToggleItemEvent.EVENT_ITEM_SELECTED );
				evt.selectedName = _selectedName ;
				this.dispatchEvent( evt );
				( event.target as BaseToggleButton).selected = true ;
			}
		}
	}
}