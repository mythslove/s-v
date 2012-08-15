package game.elements.items
{
	import flash.utils.Dictionary;
	
	import game.elements.cell.AniComponent;
	import game.elements.cell.EffectComponent;
	import game.elements.items.interfaces.IFight;
	import game.mvc.model.AniBaseModel;
	import game.mvc.model.ItemVOModel;
	import game.mvc.model.vo.AniBaseVO;
	import game.mvc.model.vo.MagicVO;

	public class Player extends LiveRole implements IFight
	{
		public var id:int ;
		public var fightDirections:Array=[2,4] ; //因为素材攻击只有四个方向
		private var _effectsArray:Vector.<EffectComponent>=new Vector.<EffectComponent>() ; //人物特效集合
		
		private var _simpleAttackAniBitmap:Dictionary ; //普通攻击的动画
		private var _magicAttackAniBitmap:Dictionary ; //法术攻击的动画
		private var _deadAniBitmap:Dictionary ; //死亡的动画
		private var _defendAttackAniBitmap:Dictionary ; //防御攻击的动画
		//==============getter/setter==================
		public function get simpleAttackAniBitmap():Dictionary{
			if(!_simpleAttackAniBitmap) {
				_simpleAttackAniBitmap= new Dictionary(true);
				createFightAniBitmap( itemVO.simpleAttackAniName, _simpleAttackAniBitmap) ;
			}
			return _simpleAttackAniBitmap ;
		}
		public function get magicAttackAniBitmap():Dictionary{
			if(!_magicAttackAniBitmap) {
				_magicAttackAniBitmap= new Dictionary(true);
				createFightAniBitmap( itemVO.magicAttackAniName, _magicAttackAniBitmap) ;
			}
			return _magicAttackAniBitmap ;
		}
		public function get deadAniBitmap():Dictionary{
			if(!_deadAniBitmap) {
				_deadAniBitmap= new Dictionary(true);
				createFightAniBitmap( itemVO.deadAniName, _deadAniBitmap) ;
			}
			return _deadAniBitmap ;
		}
		public function get defendAttackAniBitmap():Dictionary{
			if(!_defendAttackAniBitmap) {
				_defendAttackAniBitmap= new Dictionary(true);
				createFightAniBitmap( itemVO.defendAttackAniName, _defendAttackAniBitmap) ;//itemVO.standAniName
			}
			return _defendAttackAniBitmap ;
		}
		//创建战斗的动作集
		private function createFightAniBitmap( aniName:String , dic:Dictionary ):void 
		{
			var aniBaseVO:AniBaseVO ;
			var aniCom:AniComponent ;
			for( var i:int = 0 ; i<fightDirections.length ; i++)
			{
				aniBaseVO = AniBaseModel.instance.getAniBaseByName( aniName+fightDirections[i] );
				aniCom = new AniComponent(aniBaseVO);
				dic[aniBaseVO.name]  = aniCom ;
			}
		}
		
		//========================================
		
		public function Player( id:int , faceId:int, name:String)
		{
			super(faceId, name);
			this.id = id ;
		}
		
		/**
		 * 普通攻击 
		 * @param player
		 */		
		public function simpleAttack( player:IFight ):void 
		{	
			
		}
		
		/**
		 * 施法 
		 * @param magicId 法术id
		 * @param player
		 */		
		public function magic( magicId:int , player:IFight ):void 
		{	
			if(this.actionName=="stand")
			{
				this.actionName = "magic";
				addEffect( 1001 ,1 ,  2000 );
				currentAniComponent = magicAttackAniBitmap[itemVO.magicAttackAniName+direction] as AniComponent;
				if(currentAniComponent){
					currentAniComponent.setAniCycle( function():void{actionName="stand"} );
				}
			}
		}
		
		/**
		 *  播放死亡动作
		 */		
		public function playDeadAction():void 
		{	
			
		}
				
		
		/**
		 * 防御 ，挡闪
		 */		
		public function defendAttack():void
		{	
			
		}
		
		override public function update():void
		{
			if(actionName=="magic")
			{
				updateAnimation();
			}else{
				super.update();
			}
			
			updatePlayerEffects();
		}
		
		/**
		 * 更新所有的特效 
		 */		
		protected function updatePlayerEffects():void
		{
			var effect:EffectComponent ;
			for ( var i:int = 0 ; i<_effectsArray.length ; i++)
			{
				effect = _effectsArray[i] ;
				if(effect.isOver)
				{
					_effectsArray.splice(i,1) ;
					if(content.contains(effect))	{
						content.removeChild(effect);
					}
					effect.dispose(); 
					effect = null ;
					i--;
				}
				else
				{
					effect.update();
				}
			}
		}
		
		/**
		 * 添加一个人物上面的特效 
		 * @param faceId
		 * @param cycleTime
		 * @param duration 动画播放完成后，需要的持久时间长度，毫秒为单位
		 */		
		public function addEffect( faceId:int ,cycleTime:int =1 ,duration:int =0 ):void 
		{
			var magicVO:MagicVO = ItemVOModel.instance.getMagicVOByFaceId(faceId);
			var effect:EffectComponent = new EffectComponent(magicVO, deleteEffect , cycleTime , duration );
			this.content.addChild(effect);
			_effectsArray.push( effect );
		}
		
		/**
		 * 删除一个人物上面的特效 
		 * @param effect
		 */		
		public function deleteEffect( effect:EffectComponent ):void
		{
			effect.isOver = true ;
		}
		
		
		override public function dispose():void
		{
			for each( var effect:EffectComponent in _effectsArray){
				if(effect){
					effect.dispose();
				}
			}
			clearAniBitmap(_deadAniBitmap);
			clearAniBitmap(_defendAttackAniBitmap);
			clearAniBitmap(_magicAttackAniBitmap);
			clearAniBitmap(_simpleAttackAniBitmap);
			_deadAniBitmap=null ;
			_defendAttackAniBitmap=null ;
			_magicAttackAniBitmap=null ;
			_simpleAttackAniBitmap=null ;
			_effectsArray = null ;
			super.dispose();
		}
	}
}