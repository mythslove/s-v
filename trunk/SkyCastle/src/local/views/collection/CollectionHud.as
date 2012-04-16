package local.views.collection
{
	import bing.components.button.BaseButton;
	import bing.utils.ContainerUtil;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import local.model.CollectionModel;
	import local.model.PickupModel;
	import local.model.vos.CollectionVO;
	import local.model.vos.PickupVO;
	import local.views.BaseView;
	import local.views.base.Image;

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
				clearTimeout(_timeoutId);
				_timeoutId = setTimeout( close , 3000 );
			}else{
				clear();
			}
		}
		
		public function show( pvo:PickupVO ):void 
		{
			clear();
			var cvo:CollectionVO = CollectionModel.instance.getCollectionById(pvo.groupId);
			var lv:int = CollectionModel.instance.getCollLvByGrounp( cvo.groupId ) ;
			txtLevel.text =  lv+"" ;
			txtProgress.text = lv+" of 15";
			txtTitle.text = cvo.title ;
			
			var len:int = cvo.pickups.length ;
			var pickupVO:PickupVO;
			var img:Image ;
			for(var i:int =0  ; i<len ; ++i){
				pickupVO = PickupModel.instance.getPickupById(cvo.pickups[i]);
				img = new Image( pickupVO.thumbAlias , pickupVO.url);
				img.scaleX = img.scaleY = 0.5 ;
				img.alpha = 0.4 ;
				this["img"+i].addChild(img);
				if(PickupModel.instance.getMyPickupCount(pickupVO.pickupId)>0){
					if(pvo.pickupId==pickupVO.pickupId){
						img.alpha=0.2 ;
						img.scaleX = img.scaleY = 3 ;
						TweenLite.to( img , 0.5 , {scaleX:0.5 , scaleY:0.5, ease:Back.easeInOut , alpha:1 });
					}
				}
			}
		}
		
		private function clear():void
		{
			ContainerUtil.removeChildren( img0 );
			ContainerUtil.removeChildren( img1 );
			ContainerUtil.removeChildren( img2 );
			ContainerUtil.removeChildren( img3 );
			ContainerUtil.removeChildren( img4 );
		}
		
		private function close():void{
			alpha = 1 ;
			TweenLite.to(this,0.3,{x:0, ease:Back.easeIn , alpha:0 , onComplete:onTweenCom });
		}
		
		private function onTweenCom():void{
			this.visible = false ;
		}
	}
}