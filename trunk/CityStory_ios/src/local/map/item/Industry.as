package local.map.item
{
	import local.comm.GameData;
	import local.enum.BuildingStatus;
	import local.enum.PickupType;
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.map.pk.FlyLabelImage;
	import local.map.pk.PickupImages;
	import local.model.PlayerModel;
	import local.util.PopUpManager;
	import local.view.CenterViewLayer;
	import local.view.products.ProductsPopUp;
	import local.vo.BuildingVO;
	import local.vo.ProductVO;
	
	public class Industry extends Building
	{
		public function Industry(buildingVO:BuildingVO)
		{
			super(buildingVO);
			if( buildingVO.status==BuildingStatus.PRODUCTION)
			{
				//生产中
				var cha:Number =  buildingVO.statusTime-GameData.commDate.time  ;
				if(cha<=0){
					//生产完成了 , buildingVO.statusTime就是此建筑生产完成时的时间，单位为毫秒
					buildingVO.status= BuildingStatus.PRODUCTION_COMPLETE ;
				}
			}
			if( buildingVO.status==BuildingStatus.PRODUCTION_COMPLETE){
				//生产完成了，判断是否过期
				//当前时间-建造完成时的时间-过期时间 ， 如果大于0，则过期
				cha = GameData.commDate.time - buildingVO.statusTime - buildingVO.product.expireTime*1000 ;
				if(cha>=0){
					//过期了
					buildingVO.status = BuildingStatus.EXPIRED ; 
				}
			}
		}
		
		override public function update():void
		{
			super.update() ;
			if( !gameTimer && buildingVO.status==BuildingStatus.PRODUCTION_COMPLETE)
			{
				if( GameData.commDate.time - buildingVO.statusTime>buildingVO.product.expireTime*1000 )
				{
					buildingVO.status = BuildingStatus.EXPIRED ;
					showBuildingFlagIcon() ;
				}
			}
		}
		
		override public function onClick():void
		{
			if( GameData.villageMode==VillageMode.NORMAL)
			{
				if( buildingVO.status==BuildingStatus.LACK_MATERIAL)
				{
					flash(true);
					//弹出product窗口
					var productsPop:ProductsPopUp = ProductsPopUp.instance ;
					productsPop.show( this );
					PopUpManager.instance.addQueuePopUp( productsPop );
				}
				else if( buildingVO.status==BuildingStatus.PRODUCTION_COMPLETE)
				{
					flash(true);
					collect();
				}
				else if( buildingVO.status==BuildingStatus.EXPIRED)
				{
					flash(true);
					//过期
					CenterViewLayer.instance.gameTip.showBuildingTip( this ) ;
				}
				else
				{
					super.onClick();
				}
			}
			else
			{
				super.onClick();
			}
		}
		
		
		/* 收获*/
		private function collect():void
		{
			if( reduceEnergy() ){
				var pkImgs:PickupImages = new PickupImages();
				if(buildingVO.product.earnExp>0 ){
					pkImgs.addPK( PickupType.EXP , buildingVO.product.earnExp );
				}
				if( buildingVO.product.earnGoods>0 ){
					pkImgs.addPK( PickupType.GOOD , buildingVO.product.earnGoods );
				}
				pkImgs.x = screenX ;
				pkImgs.y = screenY ;
				GameWorld.instance.effectScene.addChild( pkImgs );
				
				buildingVO.status = BuildingStatus.LACK_MATERIAL ;
				buildingVO.product = null ;
				showBuildingFlagIcon();
			}
		}
		
		/**
		 * 添加产品 
		 * @param product
		 */		
		public function addProduct( product:ProductVO):void
		{
			//显示减钱
			PlayerModel.instance.changeCoin( -product.coinCost  ) ;
			var flyImg:FlyLabelImage = new FlyLabelImage( PickupType.COIN , -product.coinCost ) ;
			flyImg.x = screenX ;
			flyImg.y = screenY-20 ;
			GameWorld.instance.effectScene.addChild( flyImg );
			//开始生产
			buildingVO.product = product ;
			startProduct() ;
			removeBuildingFlagIcon() ;
		}
	}
}