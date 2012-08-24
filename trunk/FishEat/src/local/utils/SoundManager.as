package local.utils
{
	import flash.media.Sound;
	import flash.media.SoundChannel;

	public class SoundManager
	{
		[Embed(source='../assets/Sound.swf', symbol='SoundBg')] private static const  SoundBg:Class;
		[Embed(source='../assets/Sound.swf', symbol='SoundBite')] private static const  SoundBite:Class;
		[Embed(source='../assets/Sound.swf', symbol='SoundTweenCom')] private static const  SoundTweenCom:Class;
		[Embed(source='../assets/Sound.swf', symbol='SoundLevelCom')] private static const  SoundLevelCom:Class;
		[Embed(source='../assets/Sound.swf', symbol='SoundSmallPao')] private static const  SoundSmallPao:Class;
		[Embed(source='../assets/Sound.swf', symbol='SoundRiver')] private static const  SoundRiver:Class;
		[Embed(source='../assets/Sound.swf', symbol='SoundGrow')] private static const  SoundGrow:Class;
		[Embed(source='../assets/Sound.swf', symbol='SoundHurt')] private static const  SoundHurt:Class;
		
		
		public static var flag:Boolean = true ;
		private static var _soundBg:Sound ;
		private static var _soundBgChannel:SoundChannel;
		private static var _soundRiver:Sound ;
		private static var _soundRiverChannel:SoundChannel;
		private static var _soundBite:Sound ;
		private static var _soundSmallPao:Sound ;
		private static var _soundLevelCom:Sound;
		private static var _soundTweenCom:Sound;
		private static var _soundGrow:Sound ;
		private static var _soundHurt:Sound ;
		
		public static function playSoundBg():void{
			if(!_soundBg) _soundBg = new SoundBg() as Sound ;
			_soundBgChannel = _soundBg.play(0,int.MAX_VALUE );
			if(!_soundRiver) _soundRiver = new SoundRiver() as Sound ;
			_soundRiverChannel = _soundRiver.play(0,int.MAX_VALUE );
			flag =true ;
		}
		
		public static function stopSound():void{
			if(_soundBgChannel){
				_soundBgChannel.stop();
			}
			if(_soundRiverChannel){
				_soundRiverChannel.stop();
			}
			flag = false ;
		}
		
		public static function playSoundBite():void
		{
			if(flag){
				if(!_soundBite) _soundBite = new SoundBite() as Sound;
				_soundBite.play();
			}
		}
		
		public static function playSoundTweenCom():void
		{
			if(flag){
				if(!_soundTweenCom) _soundTweenCom = new SoundTweenCom() as Sound;
				_soundTweenCom.play();
			}
		}
		
		public static function playSoundSmallPao():void
		{
			if(flag){
				if(!_soundSmallPao) _soundSmallPao = new SoundSmallPao() as Sound;
				_soundSmallPao.play();
			}
		}
		
		public static function playSoundLevelCom():void
		{
			if(flag){
				if(!_soundLevelCom) _soundLevelCom = new SoundLevelCom() as Sound;
				_soundLevelCom.play();
			}
		}
		
		public static function playSoundGrow():void
		{
			if(flag){
				if(!_soundGrow) _soundGrow = new SoundGrow() as Sound;
				_soundGrow.play();
			}
		}
		
		public static function playSoundHurt():void
		{
			if(flag){
				if(!_soundHurt) _soundHurt = new SoundHurt() as Sound;
				_soundHurt.play();
			}
		}
		
	}
}