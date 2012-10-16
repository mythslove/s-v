package local.view.shop
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import local.view.tutor.TutorView;
	import local.vo.TutorItemVO;

	public class ShopOverViewHomeButton extends ShopOverViewButton
	{
		public function ShopOverViewHomeButton()
		{
			super();
		}
		
		public function showTutor():void
		{
			var globalPoint:Point = localToGlobal( new Point());
			var item:TutorItemVO = new TutorItemVO();
			item.rectType = "roundRect" ;
			item.rect = new Rectangle( globalPoint.x/root.scaleX-width*0.5,globalPoint.y/root.scaleX-height*0.5,width,height);
			item.showArrow = true ;
			item.arrowPoint = new Point(globalPoint.x/root.scaleX,globalPoint.y-height*0.5);
			TutorView.instance.showTutor( item );
		}
	}
}