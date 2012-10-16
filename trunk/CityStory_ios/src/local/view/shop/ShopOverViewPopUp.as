package local.view.shop
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.enum.BuildingType;
	import local.map.GameWorld;
	import local.util.PopUpManager;
	import local.view.base.BaseView;
	import local.view.btn.PopUpCloseButton;
	import local.view.control.BitmapTextField;
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
		
		public function ShopOverViewPopUp(){
			super();
			homeButtonBg.mouseChildren = homeButtonBg.mouseEnabled = false ;
			addEventListener(MouseEvent.CLICK , onMouseHandler );
			
			
			var title:BitmapTextField = new BitmapTextField();
			title.x = -520;
			title.y = -300;
			addChild( title );
			title.filters = [
				new GlowFilter(0x663300,1,8,8,50),
				new GlowFilter(0xffffff,1,8,8,50)
			];
			var format:TextFormat = title.defaultTextFormat;
			format.letterSpacing = 5;
			format.color = 0xFFEB56;
			format.size = 60 ;
			title.defaultTextFormat = format ;
			title.setSize(400,200);
			title.text="Market";
			addChild(title);
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			GameWorld.instance.stopRun();
			x = GameSetting.SCREEN_WIDTH>>1 ;
			y = GameSetting.SCREEN_HEIGHT>>1 ;
			TweenLite.from( this , 0.2 , { x:x-200 , ease: Back.easeOut , onComplete:tweenOver });
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
			item.arrowPoint = new Point(globalPoint.x/root.scaleX+homeButtonBg.width*0.5 , globalPoint.y);
			TutorView.instance.showTutor( item );
		}
		
		private function onMouseHandler( e:MouseEvent ):void
		{
			switch( e.target )
			{
				case btnClose:
					close();
					break ;
				case btnHomes:
					if(GameData.isShowTutor){
						TutorView.instance.clearMask();
					}
					PopUpManager.instance.addQueuePopUp( ShopPopUp.instance , true,0 );
					ShopPopUp.instance.show(BuildingType.HOME);
					close();
					break ;
				case btnDecor:
					PopUpManager.instance.addQueuePopUp( ShopPopUp.instance , true,0);
					ShopPopUp.instance.show(BuildingType.DECORATION);
					close();
					break ;
				case btnBusiness:
					PopUpManager.instance.addQueuePopUp( ShopPopUp.instance , true,0 );
					ShopPopUp.instance.show(BuildingType.BUSINESS);
					close();
					break ;
				case btnIndustry:
					PopUpManager.instance.addQueuePopUp( ShopPopUp.instance , true,0 );
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
			TweenLite.to( this , 0.2 , { x:x+200 , ease: Back.easeIn , onComplete:onTweenCom});
		}
		
		private function onTweenCom():void{
			PopUpManager.instance.removeCurrentPopup() ;
		}
		override protected function removedFromStageHandler(e:Event):void{
			super.removedFromStageHandler(e);
			GameWorld.instance.run();
		}
	}
}