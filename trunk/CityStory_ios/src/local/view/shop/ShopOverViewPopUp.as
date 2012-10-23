package local.view.shop
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.enum.BuildingType;
	import local.map.GameWorld;
	import local.util.PopUpManager;
	import local.view.base.BaseView;
	import local.view.btn.PopUpCloseButton;
	import local.view.tutor.TutorView;
	import local.vo.TutorItemVO;
	
	public class ShopOverViewPopUp extends BaseView
	{
		private static var _instance:ShopOverViewPopUp;
		public static function get instance():ShopOverViewPopUp{
			if(!_instance) _instance = new ShopOverViewPopUp();
			return _instance ;
		}
		//=====================================
		public var btnClose:PopUpCloseButton ;
		public var btnHomes:ShopOverViewHomeButton ;
		public var btnIndustry:ShopOverViewIndustryButton ;
		public var btnBusiness:ShopOverViewBusinessButton ;
		public var btnDecor:ShopOverViewDecorButton ;
		public var btnCommunity:ShopOverViewCommunityButton ;
		public var btnWonders:ShopOverViewWondersButton ;
		public var homeButtonBg:Sprite ;
		//=====================================
		
		public var isLeft:Boolean ;
		
		public function ShopOverViewPopUp(){
			super();
			homeButtonBg.mouseChildren = homeButtonBg.mouseEnabled = false ;
			addEventListener(MouseEvent.CLICK , onMouseHandler );
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			GameWorld.instance.stopRun();
			x = GameSetting.SCREEN_WIDTH>>1 ;
			y = GameSetting.SCREEN_HEIGHT>>1 ;
			var temp:int = 200 ;
			if(isLeft){
				temp = -200 ;
			}
			mouseChildren = false ;
			TweenLite.from( this , 0.3 , { x:x-temp , ease: Back.easeOut , onComplete:tweenOver });
		}
		private function tweenOver():void{
			mouseChildren=true;
			if(GameData.isShowTutor){
				showTutor();
			}
		}
		
		
		public function showTutor():void
		{
			var globalPoint:Point = localToGlobal( new Point(homeButtonBg.x+1,homeButtonBg.y+1));
			var item:TutorItemVO = new TutorItemVO();
			item.rectType = "roundRect" ;
			item.alpha = .6 ;
			item.rect = new Rectangle( globalPoint.x/root.scaleX,globalPoint.y/root.scaleX,homeButtonBg.width-2,homeButtonBg.height-4);
			item.showArrow = true ;
			item.arrowPoint = new Point(globalPoint.x/root.scaleX+homeButtonBg.width*0.5 , globalPoint.y/root.scaleX);
			TutorView.instance.showTutor( item );
		}
		
		private function onMouseHandler( e:MouseEvent ):void
		{
			isLeft = false ;
			switch( e.target )
			{
				case btnClose:
					close();
					break ;
				case btnHomes:
					if(GameData.isShowTutor){
						TutorView.instance.clearMask();
					}
					PopUpManager.instance.addQueuePopUp( ShopPopUp.instance);
					ShopPopUp.instance.show(BuildingType.HOME);
					close();
					break ;
				case btnDecor:
					PopUpManager.instance.addQueuePopUp( ShopPopUp.instance);
					ShopPopUp.instance.show(BuildingType.DECORATION);
					close();
					break ;
				case btnBusiness:
					PopUpManager.instance.addQueuePopUp( ShopPopUp.instance );
					ShopPopUp.instance.show(BuildingType.BUSINESS);
					close();
					break ;
				case btnIndustry:
					PopUpManager.instance.addQueuePopUp( ShopPopUp.instance );
					ShopPopUp.instance.show(BuildingType.INDUSTRY);
					close();
					break ;
				case btnCommunity:
					break ;
				case btnWonders:
					break ;
			}
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