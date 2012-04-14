package local.views.collection
{
	import bing.components.button.BaseButton;
	import bing.mvc.core.Model;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import local.model.CollectionModel;
	import local.model.PickupModel;
	import local.model.vos.CollectionVO;
	import local.model.vos.PickupVO;
	import local.model.vos.RewardsVO;
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
		public var img0:Sprite ,  img1:Sprite ,  img2:Sprite ,  img3:Sprite ,  img4:Sprite ;
		public var icon0:Sprite ,  icon1:Sprite ,  icon2:Sprite  ;
		public var txtName0:TextField ,  txtName1:TextField ,  txtName2:TextField ,  txtName3:TextField ,  txtName4:TextField ;
		public var txCount0:TextField ,  txCount1:TextField ,  txCount2:TextField ,  txCount3:TextField ,  txCount4:TextField ;
		public var txtReward0:TextField , txtReward1:TextField ,  txtReward2:TextField , txtReward3:TextField ,  txtReward4:TextField ;
		public var btnTurnIn:BaseButton;
		//===========================
		private var _currCollection:CollectionVO ; //当前的CollectionVO
		private var _groupId:String ; //collection组
		private var _lv:int = 0 ; //兑换等级
		
		public function CollectionItemRenderer( vo:CollectionVO )
		{
			super();
			this._currCollection = vo ;
			//判断当前组已经收集到第几等级了
			var myColl:Object = CollectionModel.instance.myCollection ;
			if(myColl && myColl.hasOwnProperty(vo.groupId)){
				_lv = myColl[vo.groupId] ;
			}
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
				if(CollectionModel.instance.myCollection && CollectionModel.instance.myCollection.get)
				count = PickupModel.instance.getMyPickupCount(pickupVO.pickupId);
				this["txCount"+i].text = "×"+count ;
				if(count==0 || count<= _lv) canCharge= false ;
			}
			//显示兑换的钱
			var iconMc:GameIcons ;
			var temp:int = 0 ;
			var exchangeRewards:RewardsVO = _currCollection.exchanges[_lv+1] ;
			if(exchangeRewards.coin>0){
				iconMc = new GameIcons();
				iconMc.gotoAndStop("coin");
				this["icon"+temp].addChild(iconMc);
				this["txtReward"+temp].text = exchangeRewards.coin +" Coin";
				++temp ;
			}
			if(exchangeRewards.energy>0){
				iconMc = new GameIcons();
				iconMc.gotoAndStop("energy");
				this["icon"+temp].addChild(iconMc);
				this["txtReward"+temp].text = exchangeRewards.energy +" Energy";
				++temp ;
			}
			if(exchangeRewards.exp>0){
				iconMc = new GameIcons();
				iconMc.gotoAndStop("exp");
				this["icon"+temp].addChild(iconMc);
				this["txtReward"+temp].text = exchangeRewards.exp +" Exp";
				++temp ;
			}
			if(exchangeRewards.stone>0){
				iconMc = new GameIcons();
				iconMc.gotoAndStop("stone");
				if(temp<3){	
					this["icon"+temp].addChild(iconMc);
					this["txtReward"+temp].text = exchangeRewards.stone +" Stone";
				}
				++temp ;
			}
			if(exchangeRewards.wood>0){
				iconMc = new GameIcons();
				iconMc.gotoAndStop("wood");
				if(temp<3){
					this["icon"+temp].addChild(iconMc);
					this["txtReward"+temp].text = exchangeRewards.wood +" Wood";
				}
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