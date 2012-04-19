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
	import local.model.vos.RewardsVO;
	import local.utils.PopUpManager;
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
		private var _wid:int ;
		public function get wid():int{
			return _wid;
		}
		private var _lv:int ;
		
		public function CollectionHud()
		{
			super();
		}
		
		override protected function added():void
		{
			_wid = width ;
			btnTurnIn.addEventListener(MouseEvent.CLICK , onTurnInClickHandler );
		}
		
		private function onTurnInClickHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			if(_cvo){
				CollectionModel.instance.sendTurnIn(_cvo.groupId , _lv) ;
				close();
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
			var collModel:CollectionModel = CollectionModel.instance ;
			_cvo = collModel.getCollectionById(pvo.groupId);
			_lv = collModel.getCollLvByGrounp( _cvo.groupId ) ;
			txtLevel.text =  _lv+"" ;
			txtProgress.text = _lv+" of 15";
			txtTitle.text = _cvo.title ;
			
			var pickupModel:PickupModel = PickupModel.instance ;
			var canExcharge:Boolean = true ;
			var len:int = _cvo.pickups.length ;
			var pickupVO:PickupVO;
			var img:Image ;
			for(var i:int =0  ; i<len ; ++i){
				pickupVO = pickupModel.getPickupById(_cvo.pickups[i]);
				img = new Image( pickupVO.thumbAlias , pickupVO.url);
				img.alpha = 0.4 ;
				img.scaleX = img.scaleY = 0.7 ;
				this["img"+i].addChild(img);
				if(pvo.pickupId==pickupVO.pickupId){
					img.alpha=0.2 ;
					img.scaleX = img.scaleY = 2 ;
					TweenLite.to( img , 1 , {scaleX:0.7 , scaleY:0.7 ,  ease:Back.easeInOut , alpha:1 });
				}
				var count:int = pickupModel.getMyPickupCount(pickupVO.pickupId) ;
				if(count<=_lv) canExcharge = false ;
				else img.alpha = 1 ;
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