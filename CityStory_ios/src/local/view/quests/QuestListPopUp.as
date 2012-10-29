package local.view.quests
{
	import bing.utils.ContainerUtil;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	import local.comm.GameSetting;
	import local.map.GameWorld;
	import local.model.QuestModel;
	import local.util.PopUpManager;
	import local.view.base.BaseView;
	import local.view.btn.PageButton;
	import local.view.btn.PopUpCloseButton;
	import local.view.control.HPageScroller;
	import local.vo.QuestVO;

	public class QuestListPopUp extends BaseView
	{
		private static var _instance:QuestListPopUp;
		public static function get instance():QuestListPopUp{
			if(!_instance) _instance = new QuestListPopUp();
			return _instance ;
		}
		//=====================================
		public var btnClose:PopUpCloseButton ;
		public var container:Sprite;
		public var btnNext:PageButton ;
		public var btnPrev:PageButton ;
		//=====================================
		private var _scroll:HPageScroller = new HPageScroller() ;
		private var _content:Sprite = new Sprite() ;
		private var _renders:Vector.<QuestListItemRenderer> = new Vector.<QuestListItemRenderer>();
		
		public var isLeft:Boolean;
		
		public function QuestListPopUp(){
			super();
			container.graphics.beginFill(0,0);
			container.graphics.drawRect(0,0,840,380);
			container.graphics.endFill();
			addChild(container);
			container.addChild(_content);
			
			btnClose.addEventListener(MouseEvent.CLICK , onMouseClickHandler );
			btnPrev.addEventListener(MouseEvent.CLICK , onMouseClickHandler );
			btnNext.addEventListener(MouseEvent.CLICK , onMouseClickHandler );
			
			_content.addEventListener(MouseEvent.CLICK , onItemHandler );
			_content.addEventListener(MouseEvent.MOUSE_DOWN , onMouseHandler );
			_content.addEventListener(MouseEvent.MOUSE_UP , onMouseHandler );
			_content.addEventListener(MouseEvent.ROLL_OUT , onMouseHandler );
			_content.addEventListener(MouseEvent.RELEASE_OUTSIDE , onMouseHandler );
			_content.addEventListener(MouseEvent.MOUSE_MOVE , onMouseHandler );
			_scroll.addEventListener( HPageScroller.SCROLL_POSITION_CHANGE , scrollChangeHandler );
			_scroll.addEventListener( HPageScroller.SCROLL_OVER , scrollChangeHandler );
		}
		
		override protected function addedToStageHandler( e:Event ):void
		{
			super.addedToStageHandler(e);
			mouseChildren=false;
			GameWorld.instance.stopRun();
			x = GameSetting.SCREEN_WIDTH>>1 ;
			y = GameSetting.SCREEN_HEIGHT>>1 ;
			var temp:int = 200 ;
			if(isLeft){
				temp = -200 ;
			}
			mouseChildren = false ;
			showList();
			
			TweenLite.from( this , 0.3 , { x:x-temp , ease: Back.easeOut , onComplete:showTweenOver });
		}
		
		private function showTweenOver():void{
			mouseChildren=true;
			if(GameSetting.SCREEN_WIDTH<1024) GameWorld.instance.visible=false;
		}
		
		private function onMouseHandler( e:MouseEvent ):void
		{
			if(e.target is QuestListItemRenderer){
				var render:QuestListItemRenderer = e.target as QuestListItemRenderer ;
				switch(e.type)
				{
					case MouseEvent.MOUSE_DOWN:
						var colorTf:ColorTransform = render.transform.colorTransform ;
						colorTf.redMultiplier = 0.5 ;
						colorTf.greenMultiplier = 0.5 ;
						colorTf.blueMultiplier = 0.5 ;
						render.transform.colorTransform = colorTf ;
						break ;
					default:
						colorTf = render.transform.colorTransform ;
						if( colorTf.redMultiplier != 1 ){
							colorTf.redMultiplier = 1 ;
							colorTf.greenMultiplier = 1 ;
							colorTf.blueMultiplier = 1 ;
							render.transform.colorTransform = colorTf ;
						}
						break ;
				}
			}
		}
		private function onMouseClickHandler(e:MouseEvent):void{
			e.stopPropagation();
			switch( e.target )
			{
				case btnClose:
					close();
					break ;
				case btnPrev:
					_scroll.prevPage();
					break ;
				case btnNext:
					_scroll.nextPage();
					break ;
			}
		}
		private function scrollChangeHandler( e:Event ):void
		{
			if(e.type == HPageScroller.SCROLL_OVER )
			{
				btnPrev.visible = _scroll.hasPrevPage() ;
				btnNext.visible = _scroll.hasNextPage() ;
			}
			else
			{
				if(btnPrev.visible || btnNext.visible){
					btnPrev.visible = btnNext.visible = false ;
				}
			}
		}
		protected function onItemHandler( e:MouseEvent):void
		{
			e.stopPropagation();
			if(e.target is QuestListItemRenderer){
				isLeft = false ;
				PopUpManager.instance.addQueuePopUp( QuestInfoPopUp.instance );
				QuestInfoPopUp.instance.show( (e.target as QuestListItemRenderer).questVO );
				close();
			}
		}
		
		
		private function showList():void
		{
			ContainerUtil.removeChildren(_content);
			_scroll.removeScrollControll();
			_scroll.addScrollControll( _content , container , 3 , 20 );
			
			var questModel:QuestModel = QuestModel.instance ;
			//判断是否有任务
			if(!questModel.currentQuests || questModel.currentQuests.length<questModel.MAX_COUNT){
				questModel.getCurrentQuests()
				questModel.checkCompleteQuest();
			}
			//当前的任务
			if(questModel.currentQuests){
				var render:QuestListItemRenderer ;
				var count:int ;
				for each( var qvo:QuestVO in questModel.currentQuests){
					if(_renders.length>count){
						render = _renders[count] as QuestListItemRenderer;
					}else{
						render = new QuestListItemRenderer();
						_renders.push( render );
					}
					_scroll.addItem( render );
					render.show( qvo );
					++count;
				}
			}
			btnPrev.visible = _scroll.hasPrevPage() ;
			btnNext.visible = _scroll.hasNextPage() ;
		}
		
		
		
		
		
		private function close():void{
			mouseChildren=false;
			var temp:int = 200 ;
			if(isLeft){
				temp = -200 ;
			}
			TweenLite.to( this , 0.3 , { x:x+temp , ease: Back.easeIn , onComplete:onTweenCom});
		}
		
		private function onTweenCom():void{
			PopUpManager.instance.removeCurrentPopup() ;
		}
		override protected function removedFromStageHandler(e:Event):void{
			super.removedFromStageHandler(e);
			GameWorld.instance.run();
			isLeft = false ;
			GameWorld.instance.visible=true;
		}
	}
}