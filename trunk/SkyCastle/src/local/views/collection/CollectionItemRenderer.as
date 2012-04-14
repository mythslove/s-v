package local.views.collection
{
	import bing.components.button.BaseButton;
	import bing.mvc.core.Model;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import local.model.CollectionModel;
	import local.model.PickupModel;
	import local.model.vos.CollectionVO;
	import local.model.vos.PickupVO;
	import local.views.BaseView;
	import local.views.base.Image;
	import local.views.icon.GameIcons;

	/**
	 * 一组收集显示 
	 * @author zzhanglin
	 */	
	public class CollectionItemRenderer extends BaseView
	{
		public var levelBar:CollectionLevelBar ;
		public var txtTitle:TextField;
//		txtName0:TextField,	img0:Sprite ,	txCount0:TextField , icon0:Spirte , txtReward0:TextField
		public var btnTurnIn:BaseButton;
		//===========================
		private var _currCollection:CollectionVO ; //当前的CollectionVO
		private var _groupId:String ; //collection组
		private var _lv:int = 0 ; //兑换等级
		
		public function CollectionItemRenderer( groupId:String=null )
		{
			super();
			this._groupId = groupId ;
			//判断当前组已经收集到第几等级了
			var myColl:Object = CollectionModel.instance.myCollection ;
			if(myColl && myColl.hasOwnProperty(groupId)){
				_lv = myColl[groupId] ;
			}
			this._currCollection = CollectionModel.instance.getCollectionByLvAndId(groupId , _lv );
		}
		
		override protected function added():void
		{
			txtTitle.text = _currCollection.title ;
			levelBar.showLevel(_lv , _lv/15 );
			var len:int = _currCollection.pickups.length ;
			var count:int ;
			var img:Image ;
			var pickupVO:PickupVO ;
			var canCharge:Boolean=true ;
			for( var i:int = 0 ; i <len ; ++i)
			{
				pickupVO = PickupModel.instance.getPickupById( _currCollection.pickups[i] );
				img = new Image("pickup"+pickupVO.name , pickupVO.url );
				this["img"+i].addChild(img);
				this["txtName"+i].text = pickupVO.name ;
				this["txCount"+i].text = "×"+CollectionModel.instance.myCollection[_currCollection.pickups[i]] ;
				count = PickupModel.instance.getMyPickupCount(pickupVO.pickupId);
				if(count>0 && count<= _lv){
					canCharge= false ;
				}
			}
			//显示兑换的钱
			var iconMc:GameIcons ;
			var temp:int = 0 ;
			if(_currCollection.exchangeCoin>0){
				iconMc = new GameIcons();
				iconMc.gotoAndStop("coin");
				this["icon"+temp].addChild(iconMc);
				this["txtReward"+temp].text = _currCollection.exchangeCoin +" Coin";
				++temp ;
			}
			if(_currCollection.exchangeEnergy>0){
				iconMc = new GameIcons();
				iconMc.gotoAndStop("energy");
				this["icon"+temp].addChild(iconMc);
				this["txtReward"+temp].text = _currCollection.exchangeEnergy +" Energy";
				++temp ;
			}
			if(_currCollection.exchangeExp>0){
				iconMc = new GameIcons();
				iconMc.gotoAndStop("exp");
				this["icon"+temp].addChild(iconMc);
				this["txtReward"+temp].text = _currCollection.exchangeExp +" Exp";
				++temp ;
			}
			if(_currCollection.exchangeStone>0){
				iconMc = new GameIcons();
				iconMc.gotoAndStop("stone");
				this["icon"+temp].addChild(iconMc);
				this["txtReward"+temp].text = _currCollection.exchangeStone +" Stone";
				++temp ;
			}
			if(_currCollection.exchangeWood>0){
				iconMc = new GameIcons();
				iconMc.gotoAndStop("wood");
				this["icon"+temp].addChild(iconMc);
				this["txtReward"+temp].text = _currCollection.exchangeWood +" Wood";
				++temp ;
			}
			//兑换按钮
			btnTurnIn.enabled = canCharge ;
			btnTurnIn.addEventListener(MouseEvent.CLICK , onTurnInClickHandler );
		}
		
		private function onTurnInClickHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			
		}
		
		override protected function removed():void
		{
			_currCollection = null ;
			btnTurnIn.removeEventListener(MouseEvent.CLICK , onTurnInClickHandler );
		}
	}
}