package local.game.elements
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import local.enum.AvatarAction;
	import local.enum.ItemType;
	import local.game.cell.BitmapMovieClip;
	import local.model.buildings.vos.BaseCharacterVO;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.CollectQueueUtil;
	import local.utils.ResourceUtil;
	
	public class Hero extends Character
	{
		
		public function Hero()
		{
			var decVO:BaseCharacterVO = new BaseCharacterVO();
			decVO.resId="Basic_AvatarMale";
			decVO.alias="Basic_AvatarMale";
			decVO.walkable=1 ;
			decVO.xSpan = 1 ;
			decVO.zSpan = 1 ;
			decVO.layer = 2 ;
			decVO.name="Sky Castle";
			decVO.description = "Click to talk.";
			decVO.type = ItemType.CHACTERS ;
			var vo:BuildingVO = new BuildingVO();
			vo.baseVO = decVO ;
			super(vo);
		}
		
		/* 添加到舞台上*/
		override protected function addedToStageHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			//获取元件
			_skin = ResourceUtil.instance.getInstanceByClassName( "Basic_AvatarMale" , buildingVO.baseVO.alias ) as MovieClip;
			if(_skin){
				_bmpMC = new BitmapMovieClip(_skin);
				itemLayer.addChild(_bmpMC);
				this.gotoAndPlay(AvatarAction.IDLE);
			}
		}
		
		override public function searchToRun(endNodeX:int, endNodeZ:int):Boolean
		{
			var result:Boolean = super.searchToRun( endNodeX, endNodeZ);
			if(result && !nextPoint){
				//如果有路，但英雄就在此路的终点
				arrived();
			}
			return result ;
		}
		
		/**
		 * 英雄到达目的地了 
		 */		
		override protected function arrived():void
		{
			var building:Building = CollectQueueUtil.instance.currentBuilding ;
			if( building){
				if(this.screenX>building.screenX){
					this.scaleX = -1;
				}else{
					this.scaleX = 1;
				}
				building.execute();
			}
		}
		
		
		override public function onClick():void
		{
			if(!CollectQueueUtil.instance.currentBuilding)
			{
				//说话
			}
		}
	}
}