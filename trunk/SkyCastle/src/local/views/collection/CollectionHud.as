package local.views.collection
{
	import bing.components.button.BaseButton;
	
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import local.views.BaseView;

	/**
	 *  主界面弹出的收集器界面
	 * @author zzhanglin
	 */	
	public class CollectionHud extends BaseView
	{
		public var txtTitle:TextField;
		public var txtLevel:TextField;
		public var txtProgress:TextField;
		public var btnTurnIn:BaseButton;
		public var img0:Sprite,img1:Sprite,img2:Sprite,img3:Sprite,img4:Sprite;
		//==========================
		private var _timeoutId:int ;
		
		public function CollectionHud()
		{
			super();
		}
		
		override public function set visible(value:Boolean):void
		{
			super.visible = value ;
			if( value ){
				_timeoutId = setTimeout( close , 3000 );
			}
		}
		
		private function close():void{
			TweenLite.to(this,0.2,{x:stage.stageWidth+width , onComplete:onTweenCom });
		}
		
		private function onTweenCom():void{
			this.visible = false ;
		}
	}
}