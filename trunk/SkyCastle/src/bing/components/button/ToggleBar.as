package bing.components.button
{
	import bing.components.BingComponent;
	import bing.components.events.ToggleItemEvent;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	/**
	 * 点击某一个按钮 ,通过selectedName来查看
	 */	
	[Event(name="itemSelected",type="bing.components.events.ToggleItemEvent")]
	
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
					btn.enabled=false;
					var evt:ToggleItemEvent = new ToggleItemEvent( ToggleItemEvent.ITEM_SELECTED );
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
					if(!btn.hasEventListener(MouseEvent.CLICK)){
						btn.addEventListener(MouseEvent.CLICK , btnClickHandler , false ,0 , true );
					}
					_toggleButtons.push( btn );
				}
			}
			selectedName =  _selectedName ;
		}
		
		private function btnClickHandler( event:MouseEvent):void 
		{
			btn = event.target as BaseToggleButton ;
			if(btn){
				_selectedName = btn.name ;
				for each(var btn:BaseToggleButton in _toggleButtons )	{
					btn.selected = false ;
					btn.enabled=true;
				}
				var evt:ToggleItemEvent = new ToggleItemEvent( ToggleItemEvent.ITEM_SELECTED );
				evt.selectedName = _selectedName ;
				this.dispatchEvent( evt );
				( event.target as BaseToggleButton).selected = true ;
				( event.target as BaseToggleButton).enabled = false ;
			}
		}
		
		override protected function removedFromStage():void
		{
			var btn:BaseToggleButton ;
			var obj:DisplayObject ;
			const LEN:int = this.numChildren ;
			for( var i:int = 0 ; i < LEN ; i++){
				obj = this.getChildAt(i);
				if(obj is BaseToggleButton)
				{
					btn = obj as BaseToggleButton ;
					if(!btn.hasEventListener(MouseEvent.CLICK)){
						btn.removeEventListener(MouseEvent.CLICK , btnClickHandler );
					}
				}
			}
		}
	}
}