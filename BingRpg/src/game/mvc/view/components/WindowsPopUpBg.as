package game.mvc.view.components
{
	import bing.utils.ContainerUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import game.mvc.base.GameContext;
	import game.utils.PopUpManager;
	
	public class WindowsPopUpBg extends BaseView
	{
		[Embed("../assets/skin/img/WindowsPopUpBg.png",scaleGridLeft="60",scaleGridRight="280",scaleGridTop="70",scaleGridBottom="160")]
		private static const BGImg:Class ;
		
		private var _bg:Sprite ;
		private var _contentPane:Sprite ;
		private var _closeBtn:WindowsCloseBtn;
		
		public function WindowsPopUpBg()
		{
			super();
			_bg = new BGImg() as Sprite ;
			addChild(_bg);
			
			_contentPane = new Sprite();
			_contentPane.x = 18;
			_contentPane.y = 40 ;
			addChild(_contentPane);
			
			_closeBtn = new WindowsCloseBtn();
			_closeBtn.x= this.width-_closeBtn.width-10 ;
			_closeBtn.y = 5 ;
			addChild(_closeBtn);
		}
		
		override protected function addToStage():void {
			super.addToStage();
			_bg.addEventListener(MouseEvent.MOUSE_DOWN , mouseDownHandler );
			_bg.addEventListener(MouseEvent.MOUSE_UP , mouseUpHandler );
			_closeBtn.addEventListener(MouseEvent.CLICK , closeBtnClickHandler , false , 0 , true );
			GameContext.instance.contextView.addEventListener(MouseEvent.ROLL_OUT , mouseUpHandler );
		}
		
		
		private function mouseDownHandler(e:MouseEvent):void 
		{
			e.stopPropagation();
			if(e.target ==_bg){
				this.startDrag(false);// ,new Rectangle(0,0,GameContext.instance.contextView.stage.stageWidth-this.width,GameContext.instance.contextView.stage.stageHeight-this.height ));
			}else{
				this.stopDrag();
			}
		}
		
		private function mouseUpHandler(e:MouseEvent):void 
		{
			e.stopPropagation();
			this.stopDrag();
		}
		
		
		public function addView( mc:DisplayObject ):void
		{
			_contentPane.addChild( mc);
			_bg.width = mc.width+40;
			_bg.height = mc.height+65;
			_closeBtn.x= this.width-_closeBtn.width-8 ;
		}
		
		public function clearView():void 
		{
			ContainerUtil.removeChildren( _contentPane );
		}
		
		public function get closeBtn():WindowsCloseBtn
		{
			return _closeBtn ;
		}
		
		private function closeBtnClickHandler(e:MouseEvent):void 
		{
			PopUpManager.removePopUp(this);
		}
		
		override protected function removeFromStage():void
		{
			_bg.removeEventListener(MouseEvent.MOUSE_DOWN , mouseDownHandler );
			_bg.removeEventListener(MouseEvent.MOUSE_UP , mouseUpHandler );
			_closeBtn.removeEventListener(MouseEvent.CLICK , closeBtnClickHandler);
			GameContext.instance.contextView.removeEventListener(MouseEvent.ROLL_OUT , mouseUpHandler );
		}
	}
}