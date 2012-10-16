package local.view.topbar
{
	import com.greensock.TweenLite;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import local.view.control.Button;
	import local.view.tutor.TutorView;
	import local.vo.TutorItemVO;
	
	public class QuestButton extends Button
	{
		public function QuestButton()
		{
			super();
		}
		
		
		public function showTutor():void
		{
			var globalPoint:Point = localToGlobal( new Point());
			var item:TutorItemVO = new TutorItemVO();
			item.rectType = "roundRect" ;
			item.rect = new Rectangle( globalPoint.x/root.scaleX,globalPoint.y/root.scaleX,width,height);
			item.showArrow = true ;
			item.arrowPoint = new Point(globalPoint.x/root.scaleX+width*0.5,globalPoint.y/root.scaleX);
			TutorView.instance.showTutor( item );
		}
		
		
		public function setVisible( value:Boolean ):void
		{
			super.visible = value ;
		}
		
		private var _tempVisible:Boolean ;
		override public function set visible(value:Boolean):void
		{
			if(_tempVisible==value) return ;
			_tempVisible = value ;
			if( value){
				alpha = 0 ;
				TweenLite.to( this , 0.25 , {alpha:1 , onComplete: onTweenCom} );
			}else{
				alpha = 1 ;
				TweenLite.to( this , 0.25 , {alpha:0 , onComplete: onTweenCom} );
			}
		}
		
		private function onTweenCom():void{
			super.visible = _tempVisible ;
		}
		
	}
}