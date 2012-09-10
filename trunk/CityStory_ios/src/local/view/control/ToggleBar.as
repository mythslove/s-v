package local.view.control
{
	import bing.utils.ContainerUtil;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import local.view.base.BaseView;

	/**
	 * 选择改变 
	 */	
	[Event(name="toggleChange", type="local.view.control.ToggleBarEvent")]
	
	/**
	 * 里面的按钮有三帧, up , down , selected-up 
	 * @author zhouzhanglin
	 */	
	public class ToggleBar extends BaseView
	{
		/** 间距*/
		public var space:int  ;
		/** 排列方式 */
		public var layout:String ;
		
		private var _selected:MovieClip ;
		public function get selected():MovieClip{ return _selected ; }
		public function set selected( value:MovieClip):void {
			if(_selected){
				_selected.mouseEnabled = true ;
				_selected.gotoAndStop("up");
			}
			_selected = value ;
			_selected.mouseEnabled = value ;
			if(value{
				_selected.gotoAndStop("up");
			}else{
				_selected.gotoAndStop("selected-up");
			}
		}
		
		private var _toggleEvt:ToggleBarEvent ;
		
		public function ToggleBar( space:int = 5 , layout:String = Layout.HORIZON)
		{
			super();
			mouseEnabled = false ;
			this.space = space ;
			this.layout = layout ;
		}
		
		public function set buttons( value:Vector.<MovieClip> ):void
		{
			ContainerUtil.removeChildren(this);
			var len:int = value.length ;
			var btn:MovieClip ;
			for( var i:int = 0 ; i <len ; ++i )
			{
				btn = value[i];
				btn.mouseChildren = false ;
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
			addEventListener(MouseEvent.MOUSE_DOWN , onMouseHandler , false , 0  , true );
			addEventListener(MouseEvent.MOUSE_UP , onMouseHandler , false , 0  , true );
			addEventListener(MouseEvent.CLICK , onMouseHandler , false , 0  , true );
		}
		
		private function onMouseHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			if(e.target is MovieClip)
			{
				var btn:MovieClip = e.target as MovieClip ;
				switch( e.type )
				{
					case MouseEvent.MOUSE_DOWN:
						btn.gotoAndStop("down");
						break ;
					case MouseEvent.CLICK :
						selected = btn ;
						if(!_toggleEvt){
							_toggleEvt = new ToggleBarEvent(ToggleBarEvent.TOGGLE_CHANGE);
						}
						_toggleEvt.selectedButton=btn;
						_toggleEvt.selectedName = btn.toString() ;
						this.dispatchEvent( _toggleEvt );
						break ;
					default:
						btn.gotoAndStop("up");
						break ;
				}
			}
		}
		
		override protected function removedFromStage():void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN , onMouseHandler );
			removeEventListener(MouseEvent.MOUSE_UP , onMouseHandler);
			removeEventListener(MouseEvent.CLICK , onMouseHandler );
		}
	}
}