package local.view.control
{
	import bing.utils.ContainerUtil;
	
	import flash.events.MouseEvent;
	
	import local.view.base.BaseView;
	/**
	 * 选择改变 
	 */	
	[Event(name="toggleChange", type="local.view.control.ToggleBarEvent")]
	
	
	public class ToggleBar extends BaseView
	{
		/** 间距*/
		public var space:int  ;
		/** 排列方式 */
		public var layout:String ;
		
		private var _selected:Button ;
		public function get selected():Boolean{ return _selected ; }
		public function set selected( value:Boolean):void {
			if(_selected){
				_selected.enabled = true ;
			}
			_selected = value ;
			_selected.enabled = value ;
		}
		
		private var _toggleEvt:ToggleBarEvent ;
		
		public function ToggleBar( space:int = 5 , layout:String = Layout.HORIZON)
		{
			super();
			mouseEnabled = false ;
			this.space = space ;
			this.layout = layout ;
		}
		
		public function set buttons( value:Vector.<Button> ):void
		{
			ContainerUtil.removeChildren(this);
			var len:int = value.length ;
			var btn:Button ;
			for( var i:int = 0 ; i <len ; ++i )
			{
				btn = value[i];
				if(layout==Layout.HORIZON){
					btn.x = (btn.width+space)*i ;
				}else if(layout==Layout.VERTICAL){
					btn.y = (btn.height+space)*i ;
				}
				addChild(btn);
			}
		}
		
		override protected function addedToStage():void
		{
			addEventListener(MouseEvent.CLICK , onMouseHandler , false , 0  , true );
		}
		
		private function onMouseHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			if(e.target is Button)
			{
				var btn:Button = e.target as Button ;
				selected = btn ;
				if(!_toggleEvt){
					_toggleEvt = new ToggleBarEvent(ToggleBarEvent.TOGGLE_CHANGE);
				}
				_toggleEvt.selectedButton=btn;
				_toggleEvt.selectedName = btn.toString() ;
				this.dispatchEvent( _toggleEvt );
			}
		}
		
		override protected function removedFromStage():void
		{
			removeEventListener(MouseEvent.CLICK , onMouseHandler );
		}
	}
}