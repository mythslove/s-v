package game.gui.app
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	
	import game.comm.GameSetting;
	import game.core.Pen;
	import game.enums.AppStatus;
	import game.gui.control.Button;
	import game.gui.control.ScrollControllerV;
	
	public class ToolBar extends Sprite
	{
		[Embed(source="../assets/BackButtonUp.png")]
		private const BackButtonUp:Class;
		[Embed(source="../assets/BackButtonDown.png")]
		private const BackButtonDown:Class;
		[Embed(source="../assets/ColorButtonUp.png")]
		private const ColorButtonUp:Class;
		[Embed(source="../assets/ColorButtonDown.png")]
		private const ColorButtonDown:Class;
		[Embed(source="../assets/DrawButtonUp.png")]
		private const DrawButtonUp:Class;
		[Embed(source="../assets/DrawButtonDown.png")]
		private const DrawButtonDown:Class;
		[Embed(source="../assets/EraserButtonUp.png")]
		private const EraserButtonUp:Class;
		[Embed(source="../assets/EraserButtonDown.png")]
		private const EraserButtonDown:Class;
		[Embed(source="../assets/MoveButtonUp.png")]
		private const MoveButtonUp:Class;
		[Embed(source="../assets/MoveButtonDown.png")]
		private const MoveButtonDown:Class;
		[Embed(source="../assets/SaveButtonUp.png")]
		private const SaveButtonUp:Class;
		[Embed(source="../assets/SaveButtonDown.png")]
		private const SaveButtonDown:Class;
		[Embed(source="../assets/SettingButtonUp.png")]
		private const SettingButtonUp:Class;
		[Embed(source="../assets/SettingButtonDown.png")]
		private const SettingButtonDown:Class;
		[Embed(source="../assets/ZoomInButtonUp.png")]
		private const ZoomInButtonUp:Class;
		[Embed(source="../assets/ZoomInButtonDown.png")]
		private const ZoomInButtonDown:Class;
		[Embed(source="../assets/ZoomOutButtonUp.png")]
		private const ZoomOutButtonUp:Class;
		[Embed(source="../assets/ZoomOutButtonDown.png")]
		private const ZoomOutButtonDown:Class;
		[Embed(source="../assets/ToolButtonLine.png")]
		private const LINE:Class;
		
		
		
		
		public var backButton:Button ;
		public var colorButton:Button ;
		public var drawButton:Button ;
		public var eraserButton:Button ;
		public var moveButton:Button ;
		public var saveButton:Button ;
		public var settingButton:Button ;
		public var zoomInButton:Button ;
		public var zoomOutButton:Button ;
		
		private var _line:Bitmap = new LINE() as Bitmap;
		private var _content:Sprite = new Sprite();
		private var _scroll:ScrollControllerV ;
		private var _wid:int = 100 ;
		private var _btnCount:int ;
		private var _selectedButton:Button ;
		
		public function ToolBar()
		{
			super();
			graphics.beginFill(0,0.7);
			graphics.drawRect(0,0,_wid,GameSetting.SCREEN_HEIGHT);
			graphics.endFill();
			init();
			configListeners();
		}
		
		public function get selectedButton():Button
		{
			return _selectedButton;
		}

		public function set selectedButton(value:Button):void
		{
			if(value!=_selectedButton){
				_selectedButton = value;
				_selectedButton.selected = true ;
			}
		}

		private function init():void
		{
			addChild(_content);
			_scroll = new ScrollControllerV(false);
			_scroll.addScrollControll(_content,this);
			
			moveButton = new Button(MoveButtonUp , MoveButtonDown , MoveButtonDown );
			addButton(moveButton);
			drawButton = new Button(DrawButtonUp , DrawButtonDown , DrawButtonDown );
			drawButton.selected = true ;
			addButton(drawButton);
			eraserButton = new Button(EraserButtonUp , EraserButtonDown , EraserButtonDown );
			addButton(eraserButton);
			zoomInButton = new Button(ZoomInButtonUp , ZoomInButtonDown );
			addButton(zoomInButton);
			zoomOutButton = new Button(ZoomOutButtonUp , ZoomOutButtonDown );
			addButton(zoomOutButton);
			colorButton = new Button(ColorButtonUp , ColorButtonDown );
			addButton(colorButton);
			saveButton = new Button(SaveButtonUp , SaveButtonDown );
			addButton(saveButton);
			settingButton = new Button(SettingButtonUp , SettingButtonDown );
			addButton(settingButton ,false);
		}
		
		private function addButton(button:Button, addLine:Boolean=true):void
		{
			button.x = ( _wid-button.width)>>1 ;
			button.y =  80*_btnCount + 20*(_btnCount+1) ; 
			if(_btnCount==0){
				button.y -=10 ;
			}
			_content.addChild(button);
			if(addLine){
				var line:Bitmap = new Bitmap(_line.bitmapData);
				line.x = ( _wid-line.width)>>1 ;
				line.y = button.y + 80+10;
				_content.addChild(line);
			}
			++_btnCount ;
		}
		
		private function configListeners():void
		{
			this.addEventListener(TouchEvent.TOUCH_TAP , onTouchHandler );
			this.addEventListener(TouchEvent.TOUCH_BEGIN , onTouchHandler );
			this.addEventListener(TouchEvent.TOUCH_END , onTouchHandler );
			this.addEventListener(TouchEvent.TOUCH_OUT , onTouchHandler );
			this.addEventListener(TouchEvent.TOUCH_ROLL_OUT , onTouchHandler );
		}
		private function onTouchHandler(e:TouchEvent):void
		{
			if(e.target is Button){
				var btn:Button = e.target as Button ;
				if(e.type==TouchEvent.TOUCH_TAP)
				{
					switch( btn )
					{
						case drawButton:
							selectedButton = btn ;
							eraserButton.selected = false ;
							moveButton.selected = false ;
							GameSetting.status = AppStatus.DRAW; 
							break ;
						case eraserButton:
							selectedButton = btn ;
							moveButton.selected = false ;
							drawButton.selected = false ;
							GameSetting.status = AppStatus.ERASER; 
							break ;
						case moveButton:
							selectedButton = btn ;
							drawButton.selected = false ;
							eraserButton.selected = false ;
							GameSetting.status = AppStatus.ZOOM;
							break ;
						case zoomInButton:
							if(GameSetting.penSize>1){
								GameSetting.penSize--;
							}
							Pen.instance.show();
							break ;
						case zoomOutButton:
							if(GameSetting.penSize<20){
								GameSetting.penSize++;
							}
							Pen.instance.show();
							break ;
					}
				}
				btn.touchHandler(e);
			}
		}
	}
}