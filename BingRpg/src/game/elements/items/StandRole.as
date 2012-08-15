package game.elements.items
{
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import game.elements.cell.AniComponent;
	import game.global.Constants;
	import game.global.Resource;
	import game.mvc.model.AniBaseModel;
	import game.mvc.model.MapDataModel;
	import game.mvc.model.vo.AniBaseVO;

	/**
	 * 只能站立的角色 
	 * @author zhouzhanglin
	 */	
	public class StandRole extends AnimationItem
	{
		protected var shadow:Bitmap;
		protected var nameLabel:TextField;
		private var _standResLoaded:Boolean = false ; //站立的资源是否都下载完成
		public var standAniBitmap:Dictionary ; //站立的动画
		private var _totalDirection:int ;
		
		//============getter/setter==================
		public function get totalDirection():int
		{
			if(_totalDirection==0){
				_totalDirection = itemVO.totalDirection.length ;
			}
			return _totalDirection ;
		}
		//==============getter/setter end=======================
		
		public function StandRole(faceId:int , name:String="" )
		{
			super(faceId);
			this.name = name ;
			init();
		}

		protected function init():void
		{
			createStandAnimation();
		}
		
		/**
		 * 创建站立的动画组件 
		 */		
		protected function createStandAnimation():void 
		{
			var aniBaseVO:AniBaseVO ;
			standAniBitmap = new Dictionary(true);
			var aniCom:AniComponent ;
			for( var i:int = 0 ; i<totalDirection ; i++)
			{
				aniBaseVO = AniBaseModel.instance.getAniBaseByName( itemVO.standAniName+itemVO.totalDirection[i] );
				aniCom = new AniComponent(aniBaseVO);
				standAniBitmap[aniBaseVO.name]  = aniCom ;
			}
		}
		
		override protected function addedToStage():void
		{
			super.addedToStage() ;
			
			shadow = new Resource.RoleShadow() as Bitmap ;
			shadow.x = -shadow.width>>1;
			shadow.y = -shadow.height>>1;
			addChildAt(shadow,0);
			showName();
			
			checkOnMask();
		}
		
		/**
		 *判断是否在遮罩上面 
		 */		
		public function checkOnMask():void
		{
			if(!MapDataModel.instance.mapDataHash)return ;
			
			if( MapDataModel.instance.mapDataHash.getValue(tilePoint.x+"-"+tilePoint.y)==Constants.MAPDATA_TYPE_MASK)
			{
				this.item.alpha=0.6;
			}else{
				this.item.alpha=1;
			}
		}
		
		private function showName():void
		{
			if(name!=""){
				nameLabel = new TextField() ;
				nameLabel.multiline=true;
				nameLabel.wordWrap=true;
				nameLabel.width = 140 ;
				nameLabel.selectable=nameLabel.mouseEnabled=false ;
				nameLabel.autoSize = TextFieldAutoSize.LEFT;
				var format:TextFormat = new TextFormat("宋体,Arial",13,0xffcc00);
				format.align = TextFormatAlign.CENTER ;
				nameLabel.defaultTextFormat = format;
				nameLabel.htmlText = name ;
				nameLabel.x = -nameLabel.width*0.5 ;
				nameLabel.y = 20 ;
				TweenMax.to(nameLabel, 0, {dropShadowFilter:{color:0, alpha:1, blurX:2, blurY:2, strength:8}});
				nameLabel.cacheAsBitmap = true ;
				content.addChild(nameLabel);
			}
		}
		
		override public function update():void
		{
			stand();
		}
		
		/**
		 * 判断站立的资源是否下载完成 
		 * @return 
		 */		
		public function get standResLoaded():Boolean
		{
			if(!_standResLoaded){
				var temp:Boolean=true ;
				for each( var component:AniComponent in standAniBitmap)
				{
					if(!component.aniBitmap){
						temp = false ;
						break ;
					}
				}
				_standResLoaded = temp ;
			}
			return _standResLoaded;
		}
		
		protected function stand():void
		{
			if(standResLoaded){
				currentAniComponent = standAniBitmap[itemVO.standAniName+direction];
				updateAnimation();
			}
		}
		
		protected function updateAnimation():void 
		{
			if(currentAniComponent && currentAniComponent.aniBitmap){
				currentAniComponent.aniBitmap.playAction( actionName+direction );
				item.bitmapData = currentAniComponent.aniBitmap.animationBmd ;
				item.x = -currentAniComponent.aniBaseVO.offsetX ;
				item.y = -currentAniComponent.aniBaseVO.offsetY ;
			}
		}
		
		override public function dispose():void
		{
			clearAniBitmap(standAniBitmap);
			standAniBitmap = null ;
			if(shadow&&shadow.bitmapData){
				shadow.bitmapData.dispose();
				shadow = null ;
			}
			nameLabel = null ;
			super.dispose();
		}
		
		/**
		 *  清除动作动画  
		 * @param aniDic
		 * 
		 */		
		protected function clearAniBitmap( aniDic:Dictionary ):void 
		{
			if(aniDic){
				for each(var aniCom:AniComponent in aniDic)
				{
					if(aniCom){
						aniCom.dispose();
					}
				}
			}
			
		}
	}
}