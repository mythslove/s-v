package game.gui.control
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	
	public class Button extends Sprite
	{
		public static const DISABLED:int = 0 ;
		public static const UP:int = 1; 
		public static const DOWN:int = 2 ;
		public static const SELECTED_UP:int = 3 ;
		
		private var _state:int = UP ;
		private var _selected:Boolean;
		private var _enabled:Boolean = true ;
		
		private var up:Bitmap;
		private var down:Bitmap;
		private var selected_up:Bitmap;
		private var disabled:Bitmap;
		private var skin:Bitmap = new Bitmap();
		
		public function Button(up:* , down:* , selected_up:*=null , disabled:* = null , configTouch:Boolean=false )
		{
			super();
			if(up){
				if(up is Class){
					this.up = new up() as Bitmap;
				}else if(up is BitmapData){
					this.up = new Bitmap(up as BitmapData);
				}else if(up is Bitmap){
					this.up = up as Bitmap;
				}
			}
			if(down){
				if(down is Class){
					this.down = new down() as Bitmap;
				}else if(down is BitmapData){
					this.down = new Bitmap(down as BitmapData);
				}else if(down is Bitmap){
					this.down = down as Bitmap;
				}
			}
			if(selected_up){
				if(selected_up is Class){
					this.selected_up = new selected_up() as Bitmap;
				}else if(selected_up is BitmapData){
					this.selected_up = new Bitmap(selected_up as BitmapData);
				}else if(selected_up is Bitmap){
					this.selected_up = selected_up as Bitmap;
				}
			}
			if(disabled){
				if(disabled is Class){
					this.disabled = new disabled() as Bitmap;
				}else if(disabled is BitmapData){
					this.disabled = new Bitmap(disabled as BitmapData);
				}else if(disabled is Bitmap){
					this.disabled = disabled as Bitmap;
				}
			}
			mouseChildren = false ;
			skin.bitmapData = this.up.bitmapData;
			addChild(skin);
			if(configTouch)
				configListeners();
		}
		
		private function configListeners():void
		{
			this.addEventListener(TouchEvent.TOUCH_BEGIN , touchHandler );
			this.addEventListener(TouchEvent.TOUCH_END , touchHandler );
			this.addEventListener(TouchEvent.TOUCH_OUT , touchHandler );
			this.addEventListener(TouchEvent.TOUCH_ROLL_OUT , touchHandler );
		}
		
		public function touchHandler(e:TouchEvent):void
		{
			switch(e.type)
			{
				case TouchEvent.TOUCH_BEGIN:
					if(!_selected && this.down){
						skin.bitmapData = down.bitmapData;
					}
					break ;
				case TouchEvent.TOUCH_END:
					if(!_selected && this.up){
						skin.bitmapData = up.bitmapData;
					}
					break ;
				default:
					if(!_selected && this.up){
						skin.bitmapData = up.bitmapData;
					}
					break ;
			}
		}

		
		
		
		public function dispose():void
		{
			this.removeEventListener(TouchEvent.TOUCH_BEGIN , touchHandler );
			this.removeEventListener(TouchEvent.TOUCH_END , touchHandler );
			this.removeEventListener(TouchEvent.TOUCH_OUT , touchHandler );
			this.removeEventListener(TouchEvent.TOUCH_ROLL_OUT , touchHandler );
			this.skin= null ;
			this.up = null ;
			this.down=null;
			this.disabled=null;
			this.selected_up = null ;
		}
		
		
		
		
		
		
		
		
		
		public function get state():int
		{
			return _state;
		}

		public function set state(value:int):void
		{
			_state = value;
		}
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			if(selected_up){
				if(value){
					this.skin.bitmapData = selected_up.bitmapData;
				}else{
					this.skin.bitmapData = up.bitmapData;
				}
			}
		}
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			mouseEnabled = value ;
			if(disabled){
				if(value){
					this.skin.bitmapData = disabled.bitmapData;
				}else{
					this.skin.bitmapData = up.bitmapData;
				}
			}
		}
	}
}