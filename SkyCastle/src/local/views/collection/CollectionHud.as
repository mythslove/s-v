package local.views.collection
{
	import bing.components.button.BaseButton;
	import bing.utils.ContainerUtil;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
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
		private var _cvo:CollectionVO ;
		
		public function CollectionHud()
		{
			super();
		}
		
		override protected function added():void
		{
			btnTurnIn.addEventListener(MouseEvent.CLICK , onTurnInClickHandler );
		}
		
		private function onTurnInClickHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			if(_cvo){
				//打开兑换窗口
			}
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
			_cvo = CollectionModel.instance.getCollectionById(pvo.groupId);
			var lv:int = CollectionModel.instance.getCollLvByGrounp( _cvo.groupId ) ;
			txtLevel.text =  lv+"" ;
			txtProgress.text = lv+" of 15";
			txtTitle.text = _cvo.title ;
			
			var canExcharge:Boolean = true ;
			var len:int = _cvo.pickups.length ;
			var pickupVO:PickupVO;
			var img:Image ;
			for(var i:int =0  ; i<len ; ++i){
				pickupVO = PickupModel.instance.getPickupById(_cvo.pickups[i]);
				img = new Image( pickupVO.thumbAlias , pickupVO.url);
				img.scaleX = img.scaleY = 0.5 ;
				img.alpha = 0.4 ;
				this["img"+i].addChild(img);
				var count:int = PickupModel.instance.getMyPickupCount(pickupVO.pickupId) ;
				if(count>0){
					if(pvo.pickupId==pickupVO.pickupId){
						img.alpha=0.2 ;
						img.scaleX = img.scaleY = 3 ;
						TweenLite.to( img , 0.5 , {scaleX:0.5 , scaleY:0.5, ease:Back.easeInOut , alpha:1 });
					}
					if(CollectionModel.instance.myCollection && CollectionModel.instance.myCollection.hasOwnProperty(_cvo.groupId)){
						if(count<=CollectionModel.instance.myCollection[_cvo.groupId])
						{
							canExcharge = false ;
						}
					}
				}
			}
			btnTurnIn.enabled = canExcharge ;
		}
		
		private function clear():void
		{
			_cvo = null ;
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