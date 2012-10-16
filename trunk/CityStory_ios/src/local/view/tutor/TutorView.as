package local.view.tutor
{
	import com.greensock.TweenLite;
	
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import local.comm.GameSetting;
	import local.model.PlayerModel;
	import local.view.CenterViewLayer;
	import local.view.base.BaseView;
	import local.vo.PlayerVO;
	import local.vo.TutorItemVO;
	
	public class TutorView extends BaseView
	{
		private static var _instance:TutorView;
		public static function get instance():TutorView{
			if(!_instance) _instance = new TutorView();
			return _instance ;
		}
		//==================================
		
		private var _me:PlayerVO ;
		private var _bottom:Sprite ;
		private var _arrow:MovieClip;
		
		public function TutorView()
		{
			mouseEnabled=false;
			_me = PlayerModel.instance.me ;
	
			_bottom = new Sprite();
			addChild(_bottom);
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			CenterViewLayer.instance.bottomBar.marketBtn.showTutor();
		}
		
		/**
		 * 外部画出缺口，然后调用endFill()
		 * @param cursorpos 指针显示的位置
		 * @param angle 角度
		 * @param alpha mask透明度
		 * @return 绘图区
		 */		
		private function getGraphics( alpha:Number ):Graphics
		{
			_bottom.graphics.clear();
			_bottom.graphics.beginFill(0,alpha);
			_bottom.graphics.drawRect(0,0,GameSetting.SCREEN_WIDTH , GameSetting.SCREEN_HEIGHT);
			return _bottom.graphics;
		}
		
		
		public function showTutor( item:TutorItemVO ):void
		{
			var g:Graphics ;
			
			if(item.rectType=="roundRect")
			{
				g = getGraphics(item.alpha);
				g.drawRoundRect( item.rect.x , item.rect.y , item.rect.width , item.rect.height ,25,25);
				g.endFill();
			}
			else if(item.rectType=="ellipse")
			{
				g = getGraphics(item.alpha);
				g.drawEllipse( item.rect.x , item.rect.y , item.rect.width , item.rect.height);
				g.endFill();
			}
			else if( item.rectType == "none")
			{
				this.clearMask();
			}
			else if(item.rectType=="all")
			{
				g = this.getGraphics(item.alpha) ;
				g.endFill();
				if(_arrow){
					_arrow.visible=false ;
				}
			}
			else if(item.rectType=="circle")
			{
				g = getGraphics(item.alpha);
				g.drawCircle( item.rect.x , item.rect.y , item.rect.width>>1);
				g.endFill();
			}
			else if(item.rectType=="tippop")
			{
//				var arrowPop:TutorPopTipPop = new TutorPopTipPop();
//				arrowPop.x = item.rect.x+ item.rect.width*0.5 ;
//				arrowPop.y = item.rect.y+item.rect.height ;
//				this.addChild( arrowPop );
//				g = getGraphics(item.alpha);
//				g.drawRoundRect( item.rect.x , item.rect.y , item.rect.width , item.rect.height ,12,12);
//				g.endFill();
			}
			else if(item.rectType=="info")
			{
//				g = this.getGraphics(0.7);
//				g.endFill();
//				var infoPop:TutorInfoPopUp = new TutorInfoPopUp();
//				infoPop.x = GameSetting.SCREEN_WIDTH>>1 ;
//				infoPop.y =GameSetting.SCREEN_HEIGHT>>1 ;
//				if(item.info){
//					infoPop.txtInfo.text = item.info ;
//				}
//				addChild(infoPop);
			}
			if(_arrow ){
				if(_arrow.visible && item.arrowPoint){
					
					_arrow.x = item.arrowPoint.x ;
					_arrow.y = item.arrowPoint. y ;
					_arrow.rotation = item.arrowAngle ;
				}else{
					_arrow.visible = false ;
				}
			}
			visible = true ;
			if(item.alpha!=0){
				_bottom.alpha = 0 ;
				TweenLite.to( _bottom , 0.4 , {alpha: item.alpha});
			}else{
				_bottom.alpha = 1;
			}
		}
		
		/**
		 * 清空显示 
		 */		
		public function clearMask():void
		{
			visible = false ;
		}
		
		override public function dispose():void
		{
			super.dispose();
			_me = null ;
			TweenLite.killTweensOf( _bottom );
			_bottom = null ;
			if(_arrow){
				_arrow.stop();
				_arrow = null ;
			}
		}
	}
}