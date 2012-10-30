package local.view.quests
{
	import bing.utils.ContainerUtil;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import local.comm.GameSetting;
	import local.map.GameWorld;
	import local.util.GameUtil;
	import local.util.PopUpManager;
	import local.view.base.BaseView;
	import local.view.btn.BackButton;
	import local.view.btn.PopUpCloseButton;
	import local.view.control.DynamicBitmapTF;
	import local.view.control.ScrollControllerH;
	import local.vo.QuestVO;
	
	public class QuestInfoPopUp extends BaseView
	{
		private static var _instance:QuestInfoPopUp;
		public static function get instance():QuestInfoPopUp{
			if(!_instance) _instance = new QuestInfoPopUp();
			return _instance ;
		}
		//=====================================
		public var btnClose:PopUpCloseButton ;
		public var btnBack:BackButton ;
		public var txtRewards:TextField;
		public var txtGoodsCoin:TextField;
		public var txtExp:TextField;
		public var txtInfo:TextField;
		public var container:Sprite ;
		public var goodsCoinMC:MovieClip;
		//===============================
		
		public var isLeft:Boolean ;
		private var _content:Sprite = new Sprite();
		private var _scroll:ScrollControllerH ;
		private var _vo:QuestVO;
		private var _renders:Vector.<QuestInfoRenderer> = new Vector.<QuestInfoRenderer>();
		private var txtTitle:DynamicBitmapTF ;
		
		public function QuestInfoPopUp()
		{
			super();
			goodsCoinMC.stop() ;
			goodsCoinMC.mouseChildren = goodsCoinMC.mouseEnabled = false ;
			txtGoodsCoin.mouseEnabled = txtExp.mouseEnabled = txtInfo.mouseEnabled = txtRewards.mouseEnabled=false;
			
			
			container.graphics.beginFill(0,0);
			container.graphics.drawRect(0,0,840,260);
			container.graphics.endFill();
			addChild(container);
			container.addChild(_content);
			_scroll = new ScrollControllerH();
			
//			Font.registerFont( EmbedsManager.FRAHV);
			var fitlers:Array = [ new GlowFilter(0x653200,1,8,8,15), new GlowFilter(0xffffff,1,8,8,15)];
			txtTitle = new DynamicBitmapTF("Verdana",GameSetting.SCREEN_WIDTH-200 , NaN , "" , "center",0,50,true,0xFFEA58,false,false,fitlers);
			txtTitle.x = -(GameSetting.SCREEN_WIDTH-200)>>1 ;
			txtTitle.y = -305 ;
			addChild(txtTitle);
			
			btnClose.addEventListener(MouseEvent.CLICK , onMouseHandler );
			btnBack.addEventListener(MouseEvent.CLICK , onMouseHandler );
		}
		
		override protected function addedToStageHandler( e:Event ):void
		{
			super.addedToStageHandler(e);
			mouseChildren=false;
			GameWorld.instance.stopRun();
			x = GameSetting.SCREEN_WIDTH>>1 ;
			y = GameSetting.SCREEN_HEIGHT>>1 ;
			
			TweenLite.from( this , 0.3 , { x:x-200 , ease: Back.easeOut , onComplete:showTweenOver });
		}
		
		private function showTweenOver():void{
			mouseChildren=true;
			if(GameSetting.SCREEN_WIDTH<1024) {
				GameWorld.instance.visible=false;
			}
		}
		
		public function show( vo:QuestVO):void
		{
			ContainerUtil.removeChildren(_content);
			_scroll.removeScrollControll();
			_vo = vo ;
			if(_vo){
				var len:int = _vo.tasks.length ;
				var render:QuestInfoRenderer ;
				for( var i:int = 0 ; i<len ; ++i){
					if(i<_renders.length){
						render = _renders[i] ;
					}else{
						render = new QuestInfoRenderer();
						_renders.push( render );
					}
					_content.addChild( render);
					render.x= 450*i ;
					render.show( _vo.tasks[i] );
				}
				_scroll.addScrollControll( _content , container);
				
				txtInfo.text = _vo.info ;
				txtTitle.text = _vo.title ;
				GameUtil.boldTextField( txtRewards , GameUtil.localizationString("rewards")+":" );
			}
		}
		
		
		private function onMouseHandler( e:MouseEvent ):void
		{
			switch( e.target )
			{
				case btnClose:
					close();
					break ;
				case btnBack:
					isLeft = true ;
					close();
					QuestListPopUp.instance.isLeft = true ;
					PopUpManager.instance.addQueuePopUp( QuestListPopUp.instance );
					break ;
			}
		}
		private function close():void{
			GameWorld.instance.visible=true;
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
			GameWorld.instance.visible=true;
			isLeft = false ;
			_vo = null ;
		}
	}
}