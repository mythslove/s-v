package  local.views.tooltip
{
	import flash.accessibility.AccessibilityProperties;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class GameToolTip extends Sprite
	{
		public var background:Sprite ;
		public var txtTitle:TextField;
		public var txtInfo:TextField ;
		//------------------------------------------*
		private var _hitSprite:DisplayObject;
		public const offsetX:int = 5 ;
		public const offsetY:int = 5;
		
		private static var _instance:GameToolTip ;
		public function GameToolTip()
		{
			super();
			
			mouseChildren = mouseEnabled= visible= false ;
			cacheAsBitmap = true ;
		}
		
		public static function get instance():GameToolTip{
			if(!_instance) _instance = new GameToolTip();
			return _instance ;
		}
		
		public function register( hitSprite:InteractiveObject , stage:Stage ,  info:String , title:String = "" ):void
		{
			unRegister(hitSprite);
			stage.addChild(this);
			var prop:AccessibilityProperties=new AccessibilityProperties();
			prop.description=info;
			prop.name=title;
			hitSprite.accessibilityProperties=prop;
			hitSprite.addEventListener(MouseEvent.MOUSE_OVER , mouseEventHandler );
			if(this.visible && this._hitSprite==hitSprite){
				show(hitSprite);
				move(stage.mouseX , stage.mouseY);
			}
		}
		
		public function unRegister( hitSprite:InteractiveObject):void {
			hitSprite.removeEventListener(MouseEvent.MOUSE_OVER, mouseEventHandler);
		}
		
		protected function mouseEventHandler(e:MouseEvent):void
		{
			switch (e.type)
			{
				case MouseEvent.ROLL_OUT:
				case MouseEvent.MOUSE_OUT:
					this.hide();
					break;
				case MouseEvent.MOUSE_MOVE:
					this.move(e.stageX, e.stageY);
					break;
				case MouseEvent.MOUSE_OVER:
					this.show(e.target as InteractiveObject);
					if(_hitSprite) this.move(e.stageX, e.stageY) ;
					break;
			}
		}
		
		protected function show( hitSprite:InteractiveObject ):void
		{
			if(!hitSprite){
				this.hide();
				return ;
			}
			_hitSprite=hitSprite;
			if( !_hitSprite.hasEventListener(MouseEvent.MOUSE_OUT))
				_hitSprite.addEventListener(MouseEvent.MOUSE_OUT, this.mouseEventHandler,false,0,true);
			if( !_hitSprite.hasEventListener(MouseEvent.ROLL_OUT))
				_hitSprite.addEventListener(MouseEvent.ROLL_OUT, this.mouseEventHandler,false,0,true);
			if( !_hitSprite.hasEventListener(MouseEvent.MOUSE_MOVE))
				_hitSprite.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseEventHandler,false,0,true);
			if(_hitSprite.accessibilityProperties){
				txtInfo.text=_hitSprite.accessibilityProperties.description;
				txtTitle.text=_hitSprite.accessibilityProperties.name;
				update();
			}else{
				hide();
			}
		}
		
		public function update():void
		{
			if (txtTitle.text == "" || txtInfo.text == "") {
				txtInfo.y = txtTitle.y;
			} else {
				txtInfo.y = txtTitle.y + txtTitle.textHeight ;
			}
			txtInfo.width = 300;
			txtTitle.width = 300;
			if (txtInfo.textWidth < 275)
			{
				txtInfo.width = txtInfo.textWidth + 10;
			} else {
				txtInfo.width = 285;
			}
			if (txtTitle.textWidth < 275) {
				txtTitle.width = txtTitle.textWidth + 10;
			} else {
				txtTitle.width = 285;
			}
			txtTitle.height = txtTitle.textHeight + 10;
			if (txtInfo.textWidth == 0) {
				txtInfo.width = 0;
			}
			if (txtTitle.textWidth == 0) {
				txtTitle.width = 0;
			}
			var maxWid:int = Math.max(txtTitle.textWidth, txtInfo.textWidth);
			if (txtInfo.numLines <= 1 && txtTitle.numLines <= 1 || maxWid < 300) {
				background.width = maxWid + 20;
			} else {
				background.width = 300;
			}
			txtInfo.height = txtInfo.textHeight + 10;
			background.height = txtInfo.height + txtInfo.y;
			if (txtInfo.textHeight == 0) {
				background.height = txtTitle.height + txtTitle.y;
			}
		}
		
		protected function move( stageX:int , stageY:int ):void
		{
			if (!visible) visible=true;
			//鼠标在场景右侧
			if (stageX > this.stage.stageWidth * 0.5) {
				this.x= stageX -offsetX - width  ;
			} else {
				this.x= stageX + offsetX;
			}
			//鼠标在场景上侧
			if (stageY < this.height) {
				this.y=stageY + offsetY ;
			} else {
				this.y= stageY - height - offsetY;
			}
		}
		
		protected function hide():void
		{
			txtInfo.text="";
			txtTitle.text="";
			if (_hitSprite)
			{
				_hitSprite.removeEventListener(MouseEvent.MOUSE_OUT, this.mouseEventHandler);
				_hitSprite.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseEventHandler);
				_hitSprite.removeEventListener(MouseEvent.ROLL_OUT, this.mouseEventHandler);
				_hitSprite=null;
				visible=false;
			}
		}
	}
}