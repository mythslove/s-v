package local.view.tutor
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	import local.comm.GameSetting;
	import local.model.PlayerModel;
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
		private var _shape:Shape ;
		private var _bottom:Sprite ;
		private var _arrow:MovieClip;
		
		public function TutorView()
		{
			mouseEnabled=false;
			_me = PlayerModel.instance.me ;
	
			_bottom = new Sprite();
			addChild(_bottom);
			
			_shape = new Shape();
			addChild(_shape);
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			
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
			alpha = 0 ;
			_bottom.graphics.clear();
			_bottom.graphics.beginFill(0,alpha);
			_bottom.graphics.drawRect(0,0,GameSetting.SCREEN_WIDTH , GameSetting.SCREEN_HEIGHT);
			return _bottom.graphics;
		}
		
		
		public function showTutor( item:TutorItemVO ):void
		{
			var shapeG:Graphics = _shape.graphics ;
			shapeG.clear();
			
			var alphas:Array = [0,0.2,0.4];
			var ratios:Array = [40,90,160] ;
			var g:Graphics ;
			if(item.rectType=="roundRect")
			{
				g = getGraphics(item.alpha);
				g.drawRoundRect( item.rect.x , item.rect.y , item.rect.width , item.rect.height ,25,25);
				g.endFill();
				
				var matx:Matrix = new Matrix();
				matx.createGradientBox(item.rect.width*3 , item.rect.height*3,0,item.rect.x-item.rect.width , item.rect.y-item.rect.height);
				shapeG.beginGradientFill(GradientType.RADIAL,[0,0,0],alphas,ratios,matx);
				shapeG.drawRect(0,0,GameSetting.SCREEN_WIDTH , GameSetting.SCREEN_HEIGHT);
				shapeG.endFill();
			}
			else if(item.rectType=="ellipse")
			{
				g = getGraphics(item.alpha);
				g.drawEllipse( item.rect.x , item.rect.y , item.rect.width , item.rect.height);
				g.endFill();
				
				matx = new Matrix();
				matx.createGradientBox(item.rect.width*3 , item.rect.height*3,0,item.rect.x-item.rect.width , item.rect.y-item.rect.height);
				shapeG.beginGradientFill(GradientType.RADIAL,[0,0,0],alphas,ratios,matx);
				shapeG.drawRect(0,0,GameSetting.SCREEN_WIDTH , GameSetting.SCREEN_HEIGHT);
				shapeG.endFill();
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
				
				matx = new Matrix();
				matx.createGradientBox(item.rect.width*3 , item.rect.height*3,0,item.rect.x-item.rect.width*1.5 , item.rect.y-item.rect.height*1.5);
				shapeG.beginGradientFill(GradientType.RADIAL,[0,0,0],alphas,ratios,matx);
				shapeG.drawRect(0,0,GameSetting.SCREEN_WIDTH , GameSetting.SCREEN_HEIGHT);
				shapeG.endFill();
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
//				
//				matx = new Matrix();
//				matx.createGradientBox(item.rect.width*3 , item.rect.height*3,0,item.rect.x-item.rect.width , item.rect.y-item.rect.height);
//				shapeG.beginGradientFill(GradientType.RADIAL,[0,0,0],alphas,ratios,matx);
//				shapeG.drawRect(0,0,GameSetting.SCREEN_WIDTH , GameSetting.SCREEN_HEIGHT);
//				shapeG.endFill();
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
		}
		
		/**
		 * 清空显示 
		 */		
		public function clearMask():void
		{
			if(_arrow){
				_arrow.visible=false ;
			}
			if(_bottom){
				_bottom.graphics.clear();
			}
			if(_shape){
				_shape.graphics.clear();
			}
		}
	}
}