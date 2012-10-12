package local.view.shop
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import feathers.controls.Button;
	
	import local.comm.CommUISetting;
	import local.comm.GameSetting;
	import local.map.GameWorld;
	import local.util.EmbedManager;
	import local.util.PopUpManager;
	import local.view.base.BaseView;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class ShopOverViewPopUp extends BaseView
	{
		private static var _instance:ShopOverViewPopUp;
		public static function get instance():ShopOverViewPopUp{
			if(!_instance) _instance = new ShopOverViewPopUp();
			return _instance ;
		}
		//=====================================
		private var _btnClose:Button ;
		private var _btnHomes:Button ;
		private var _btnIndustry:Button ;
		private var _btnBusiness:Button ;
		private var _btnDecor:Button ;
		private var _btnCommunity:Button ;
		private var _btnWonders:Button ;
		
		private var _wid:Number ;
		private var _het:Number ;
		
		public function ShopOverViewPopUp()
		{
			super();
			init();
		}
		
		private function init():void
		{
			var img:Image = EmbedManager.getUIImage( CommUISetting.POPUPBG ) ;
			addChild( img );
			_wid = img.width ;
			_het = img.height ;
			pivotX = _wid>>1 ;
			pivotY = _het>>1 ;
			
			
			img = EmbedManager.getUIImage( "ShopOverViewTitle_en" ) ;
			img.x = (_wid - img.width)>>1;
			img.y = 10 ;
			addChild(img);
			
			var btnBgs:Vector.<Image>=new Vector.<Image>(6,true) ;
			var row:int , col:int ;
			for(var i:int = 0 ; i<6 ; ++i)
			{
				img = EmbedManager.getUIImage( "ShopOverViewItemBg" ) ;
				img.x = 80 + (img.width+30)*col ;
				img.y = 150 + (img.height+30)*row ;
				++col;
				if(col==3) {
					col = 0 ;
					++row ;
				}
				btnBgs[i] = img ;
				addChild(img);
			}
			
			var tempW:Number , tempH:Number ;
			img = EmbedManager.getUIImage( "ShopOverViewHomeButton" );
			tempW = img.width;
			tempH = img.height ;
			_btnHomes = new Button();
			_btnHomes.x = btnBgs[0].x+(btnBgs[0].width-img.width)*0.5 ;
			_btnHomes.y = btnBgs[0].y+(btnBgs[0].height-img.height)*0.5 ;
			_btnHomes.defaultSkin = img ;
			addChild(_btnHomes);
			img = EmbedManager.getUIImage( "HOMES_en" );
			img.x = (tempW-img.width)*0.5 ;
			img.y = tempH-img.height ;
			img.touchable = false ;
			_btnHomes.addChild( img );
			_btnHomes.onRelease.add(onClickHandler);
			
			
			img = EmbedManager.getUIImage( "ShopOverViewCommunityButton" );
			tempW = img.width;
			tempH = img.height ;
			_btnCommunity = new Button();
			_btnCommunity.x = btnBgs[1].x+(btnBgs[1].width-img.width)*0.5 ;
			_btnCommunity.y = btnBgs[1].y+(btnBgs[1].height-img.height)*0.5 ;
			_btnCommunity.defaultSkin = img ;
			addChild(_btnCommunity);
			img = EmbedManager.getUIImage( "COMMUNITY_en" );
			img.x = (tempW-img.width)*0.5 ;
			img.y = tempH-img.height ;
			img.touchable = false ;
			_btnCommunity.addChild( img );
			_btnCommunity.onRelease.add(onClickHandler);
			
			
			img = EmbedManager.getUIImage( CommUISetting.POPUPCLOSEBUTTONUP );
			_btnClose = new Button();
			_btnClose.defaultSkin = img ;
			addChild(_btnClose);
			_btnClose.x = _wid - img.width - 10 ;
			_btnClose.y = 10 ;
			_btnClose.onRelease.add(onClickHandler);
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			touchable=true;
			GameWorld.instance.stopRun();
			x = GameSetting.SCREEN_WIDTH>>1 ;
			y = GameSetting.SCREEN_HEIGHT>>1 ;
			
			scaleX = scaleY= 0 ;
			alpha = 0 ;
			TweenLite.to( this , 0.3 , { scaleX:1 , scaleY:1 , alpha:1  , ease: Back.easeOut , onComplete:function():void{
				if(!GameSetting.isIpad) GameWorld.instance.visible=false;
			} });
		}
		
		private function onClickHandler( btn:Button ):void
		{
			switch( btn)
			{
				case _btnClose:
					close();
					break ;
			}
		}
		
		private function close():void{
			touchable=false;
			TweenLite.to( this , 0.4 , { scaleX:0.3 , scaleY:0 , alpha:0 , ease: Back.easeIn , onComplete:onTweenCom});
		}
		
		private function onTweenCom():void{
			PopUpManager.instance.removeCurrentPopup() ;
		}
		override protected function removedFromStageHandler(e:Event):void{
			super.removedFromStageHandler(e);
			GameWorld.instance.run();
			GameWorld.instance.visible=true;
		}
	}
}