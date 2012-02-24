package bing.gl.nd2d.iso
{
	import de.nulldesign.nd2d.display.Sprite2D;
	import de.nulldesign.nd2d.materials.Sprite2DMaterial;
	import de.nulldesign.nd2d.materials.texture.Texture2D;
	
	public class N2DIsoSprite extends Sprite2D
	{
		public function N2DIsoSprite(textureObject:Texture2D=null)
		{
			super(textureObject);
			if(textureObject){
				pivot.x = textureObject.bitmapWidth>>1;
				pivot.y = textureObject.bitmapHeight>>1;
			}
		}
		
		override public function setTexture(value:Texture2D):void
		{
			setMaterial(new Sprite2DMaterial());
			super.setTexture(value);
			if(value){
				pivot.x = value.bitmapWidth>>1;
				pivot.y = value.bitmapHeight>>1;
			}
		}
	}
}