package local.game.fish
{
	import local.utils.AssetsManager;
	
	import starling.display.MovieClip;
	
	public class BaseFish extends MovieClip
	{
		public var mx:Number = 1 ;
		public var my:Number = 0 ;
		
		public function BaseFish( name:String )
		{
			super(AssetsManager.createTextureAtlas("fishTexture").getTextures(name) , 12 );
			pivotX = texture.width>>1  ;
			pivotY = texture.height>>1  ;
			touchable = false ;
		}
		
		public function update():void
		{
			x+=mx ;
			if( x<-texture.width ){
				mx=Math.random() ;
			}else if(x>960+texture.width){
				mx = -Math.random() ;
			}
			
			if(mx>0)  scaleX=-1 ;
			else scaleX = 1 ;
		}
	}
}