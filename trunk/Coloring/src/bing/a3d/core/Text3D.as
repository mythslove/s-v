package bing.a3d.core
{
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.primitives.Plane;
	import alternativa.engine3d.resources.BitmapTextureResource;
	
	import flash.display.BitmapData;
	import flash.text.TextField;
	
	public class Text3D extends Plane
	{
		private var _text:TextField;
		private var _bmd:BitmapData;
		private var _texture:TextureMaterial; 
		
		public function Text3D( text:TextField = null )
		{
			super();
			this.text = text ;
		}

		public function get text():TextField
		{
			return _text;
		}

		public function set text(value:TextField):void
		{
			if(_bmd) _bmd.dispose() ;
			_text = value;
			if(_text)
			{
				var temp:int = _text.width ;
				var wid:int  ;
				if(temp<4) wid=4;
				else if(temp<16) wid=16 ;
				else if(temp<64) wid=64 ;
				else if(temp<128) wid=128 ;
				else if(temp<256) wid=256 ;
				else if(temp<1024) wid = 1024 ;
				else wid = 2048 ;
				
				temp = _text.height ;
				var het:int  ;
				if(temp<4) het=4;
				else if(temp<16) het=16 ;
				else if(temp<64) het=64 ;
				else if(temp<128) het=128 ;
				else if(temp<256) het=256 ;
				else if(temp<1024) het = 1024 ;
				else het = 2048 ;
				
				_bmd = new BitmapData( wid,het , true,0x000000 );
				_bmd.draw( _text );
				_texture = new TextureMaterial( new BitmapTextureResource( _bmd ));
				_texture.useDiffuseAlphaChannel = true;
				this.setMaterialToAllSurfaces( _texture);
				
			}
		}

	}
}