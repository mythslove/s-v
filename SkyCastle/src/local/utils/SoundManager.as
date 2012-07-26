package local.utils
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	public class SoundManager
	{
		private static var _instance:SoundManager ;
		public static function get instance():SoundManager
		{
			if(!_instance){
				_instance = new SoundManager();
			}
			return _instance ;
		}
		//================================
		/*
		SoundBuild,SoundChopRock,SoundChopStone,SoundChopWood,SoundFinishBuilding
		SoundGreatWork,SoundHitMonster,SoundLevelup,SoundNewQuest,SoundPickupCoin
		SoundPickupEnergy,SoundPickupStone,SoundPickupWood,SoundPickupXp,SoundPopupShow,
		SoundSpecialClick,SoundBulidDown,SoundRemoveBuild,SoundClick,SoundLootdrop,SoundPayCash
		SoundCollect , MusicBackground,SoundSpecialPopShow , SoundMonsterRoar
		*/
		public var musicFlag:Boolean = true ;
		public var soundFlag:Boolean = true ;
		
		private const RES_ID:String = "init_SoundsCore";
		private var _soundBuild:Sound, _soundChopRock:Sound, _soundChopStone:Sound, _soundChopWood:Sound, _soundFinishBuilding:Sound ;
		private var _soundGreatWork:Sound, _soundHitMonster:Sound, _soundLevelup:Sound, _soundNewQuest:Sound, _soundPickupCoin:Sound ;
		private var _soundPickupEnergy:Sound, _soundPickupStone:Sound, _soundPickupWood:Sound, _soundPickupXp:Sound, _soundPopupShow:Sound;
		private var _soundSpecialClick:Sound, _soundBulidDown:Sound, _soundRemoveBuild:Sound,_soundLootdrop:Sound , _soundClick:Sound;
		private var _soundPayCash:Sound , _soundCollect:Sound , _musicBackground:Sound, _soundSpecialPopShow:Sound ;
		private var _bgChannel:SoundChannel , _soundMonsterRoar:Sound ;
		
		
		public function stopMusic():void
		{
			if(_bgChannel) _bgChannel.stop() ;
			_bgChannel = null ;
		}
		
		public function playMusicBackground():void
		{
			if(musicFlag){
				if(!_musicBackground){
					_musicBackground = ResourceUtil.instance.getInstanceByClassName( RES_ID , "local.sounds.MusicBackground" ) as Sound;
				}
				if(_musicBackground && !_bgChannel) {
					_bgChannel = _musicBackground.play(0,int.MAX_VALUE);
					var transform:SoundTransform = _bgChannel.soundTransform ;
					transform.volume = 0.5;
					_bgChannel.soundTransform =transform ;
				}
			}
		}
		
		public function playSoundBuild():void
		{
			if(soundFlag){
				if(!_soundBuild){
					_soundBuild = ResourceUtil.instance.getInstanceByClassName( RES_ID , "local.sounds.SoundBuild" ) as Sound;
				}
				if(_soundBuild) _soundBuild.play();
			}
		}
		public function playSoundChopRock():void
		{
			if(soundFlag){
				if(!_soundChopRock){
					_soundChopRock = ResourceUtil.instance.getInstanceByClassName( RES_ID , "local.sounds.SoundChopRock" ) as Sound;
				}
				if(_soundChopRock) _soundChopRock.play();
			}
		}
		public function playSoundChopStone():void
		{
			if(soundFlag){
				if(!_soundChopStone){
					_soundChopStone = ResourceUtil.instance.getInstanceByClassName( RES_ID , "local.sounds.SoundChopStone" ) as Sound;
				}
				if(_soundChopStone) _soundChopStone.play();
			}
		}
		public function playSoundChopWood():void
		{
			if(soundFlag){
				if(!_soundChopWood){
					_soundChopWood = ResourceUtil.instance.getInstanceByClassName( RES_ID , "local.sounds.SoundChopWood" ) as Sound;
				}
				if(_soundChopWood) _soundChopWood.play();
			}
		}
		public function playSoundFinishBuilding():void
		{
			if(soundFlag){
				if(!_soundFinishBuilding){
					_soundFinishBuilding = ResourceUtil.instance.getInstanceByClassName( RES_ID , "local.sounds.SoundFinishBuilding" ) as Sound;
				}
				if(_soundFinishBuilding) _soundFinishBuilding.play();
			}
		}
		public function playSoundGreatWork():void
		{
			if(soundFlag){
				if(!_soundGreatWork){
					_soundGreatWork = ResourceUtil.instance.getInstanceByClassName( RES_ID , "local.sounds.SoundGreatWork" ) as Sound;
				}
				if(_soundGreatWork) _soundGreatWork.play();
			}
		}
		public function playSoundHitMonster():void
		{
			if(soundFlag){
				if(!_soundHitMonster){
					_soundHitMonster = ResourceUtil.instance.getInstanceByClassName( RES_ID , "local.sounds.SoundHitMonster" ) as Sound;
				}
				if(_soundHitMonster) _soundHitMonster.play();
			}
		}
		
		public function playSoundMonsterRoar():void
		{
			if(soundFlag){
				if(!_soundMonsterRoar){
					_soundMonsterRoar = ResourceUtil.instance.getInstanceByClassName( RES_ID , "local.sounds.SoundMonsterRoar" ) as Sound;
				}
				if(_soundMonsterRoar) _soundMonsterRoar.play();
			}
		}
		
		
		public function playSoundLevelup():void
		{
			if(soundFlag){
				if(!_soundLevelup){
					_soundLevelup = ResourceUtil.instance.getInstanceByClassName( RES_ID , "local.sounds.SoundLevelup" ) as Sound;
				}
				if(_soundLevelup) _soundLevelup.play();
			}
		}
		public function playSoundNewQuest():void
		{
			if(soundFlag){
				if(!_soundNewQuest){
					_soundNewQuest = ResourceUtil.instance.getInstanceByClassName( RES_ID , "local.sounds.SoundNewQuest" ) as Sound;
				}
				if(_soundNewQuest) _soundNewQuest.play();
			}
		}
		public function playSoundPickupCoin():void
		{
			if(soundFlag){
				if(!_soundPickupCoin){
					_soundPickupCoin = ResourceUtil.instance.getInstanceByClassName( RES_ID , "local.sounds.SoundPickupCoin" ) as Sound;
				}
				if(_soundPickupCoin) _soundPickupCoin.play();
			}
		}
		public function playSoundPickupEnergy():void
		{
			if(soundFlag){
				if(!_soundPickupEnergy){
					_soundPickupEnergy = ResourceUtil.instance.getInstanceByClassName( RES_ID , "local.sounds.SoundPickupEnergy" ) as Sound;
				}
				if(_soundPickupEnergy) _soundPickupEnergy.play();
			}
		}
		public function playSoundPickupStone():void
		{
			if(soundFlag){
				if(!_soundPickupStone){
					_soundPickupStone = ResourceUtil.instance.getInstanceByClassName( RES_ID , "local.sounds.SoundPickupStone" ) as Sound;
				}
				if(_soundPickupStone) _soundPickupStone.play();
			}
		}
		public function playSoundPickupWood():void
		{
			if(soundFlag){
				if(!_soundPickupWood){
					_soundPickupWood = ResourceUtil.instance.getInstanceByClassName( RES_ID , "local.sounds.SoundPickupWood" ) as Sound;
				}
				if(_soundPickupWood) _soundPickupWood.play();
			}
		}
		public function playSoundPickupXp():void
		{
			if(soundFlag){
				if(!_soundPickupXp){
					_soundPickupXp = ResourceUtil.instance.getInstanceByClassName( RES_ID , "local.sounds.SoundPickupXp" ) as Sound;
				}
				if(_soundPickupXp) _soundPickupXp.play();
			}
		}
		public function playSoundPopupShow():void
		{
			if(soundFlag){
				if(!_soundPopupShow){
					_soundPopupShow = ResourceUtil.instance.getInstanceByClassName( RES_ID , "local.sounds.SoundPopupShow" ) as Sound;
				}
				if(_soundPopupShow) _soundPopupShow.play();
			}
		}
		public function playSoundSpecialPopShow():void
		{
			if(soundFlag){
				if(!_soundSpecialPopShow){
					_soundSpecialPopShow = ResourceUtil.instance.getInstanceByClassName( RES_ID , "local.sounds.SoundSpecialPopShow" ) as Sound;
				}
				if(_soundSpecialPopShow) _soundSpecialPopShow.play();
			}
		}
		public function playSoundSpecialClick():void
		{
			if(soundFlag){
				if(!_soundSpecialClick){
					_soundSpecialClick = ResourceUtil.instance.getInstanceByClassName( RES_ID , "local.sounds.SoundSpecialClick" ) as Sound;
				}
				if(_soundSpecialClick) _soundSpecialClick.play();
			}
		}
		public function playSoundBulidDown():void
		{
			if(soundFlag){
				if(!_soundBulidDown){
					_soundBulidDown = ResourceUtil.instance.getInstanceByClassName( RES_ID , "local.sounds.SoundBulidDown" ) as Sound;
				}
				if(_soundBulidDown) _soundBulidDown.play();
			}
		}
		public function playSoundRemoveBuild():void
		{
			if(soundFlag){
				if(!_soundRemoveBuild){
					_soundRemoveBuild = ResourceUtil.instance.getInstanceByClassName( RES_ID , "local.sounds.SoundRemoveBuild" ) as Sound;
				}
				if(_soundRemoveBuild) _soundRemoveBuild.play();
			}
		}
		public function playSoundClick():void
		{
			if(soundFlag){
				if(!_soundClick){
					_soundClick = ResourceUtil.instance.getInstanceByClassName( RES_ID , "local.sounds.SoundClick" ) as Sound;
				}
				if(_soundClick) _soundClick.play();
			}
		}
		public function playSoundLootdrop():void
		{
			if(soundFlag){
				_soundLootdrop = ResourceUtil.instance.getInstanceByClassName( RES_ID , "local.sounds.SoundLootdrop" ) as Sound;
				if(_soundLootdrop) {
					_soundLootdrop.play();
					_soundLootdrop = null ;
				}
			}
		}
		public function playSoundPayCash():void
		{
			if(soundFlag){
				if(!_soundPayCash){
					_soundPayCash = ResourceUtil.instance.getInstanceByClassName( RES_ID , "local.sounds.SoundPayCash" ) as Sound;
				}
				if(_soundPayCash) _soundPayCash.play();
			}
		}
		public function playSoundCollect():void
		{
			if(soundFlag){
				if(!_soundCollect){
					_soundCollect = ResourceUtil.instance.getInstanceByClassName( RES_ID , "local.sounds.SoundCollect" ) as Sound;
				}
				if(_soundCollect) _soundCollect.play();
			}
		}
		
	}
}