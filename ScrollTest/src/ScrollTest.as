package
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	[SWF(width="800",height="600",frameRate="60")]
	public class ScrollTest extends Sprite
	{
		public function ScrollTest()
		{
			stage.align = "TL";
			stage.scaleMode = "noScale";
			
			var container:Sprite = new Sprite();
			container.graphics.beginFill(0xffcc00);
			container.graphics.drawRect(0,0,700,400 );
			container.graphics.endFill() ;
			container.x = container.y = 20 ;
			addChild(container);
			
			var content:Sprite = new Sprite();
			container.addChild( content );
			
			var scroller:HPageScroller = new HPageScroller();
			scroller.addScrollControll( container,content,3);
			for( var i:int = 0  ; i<14 ; ++i){
				scroller.addItem( createItem(i) );
			}
		}
		
		
		private function createItem( index:int ):Sprite
		{
			var sprite:Sprite = new Sprite();
			
			sprite.graphics.beginFill(0xff0000);
			sprite.graphics.drawRect(0,0,200,380 );
			sprite.graphics.endFill() ;
			
			var tf:TextField = new TextField();
			tf.width=100;
			tf.text = index+"" ;
			sprite.addChild(tf);
			
			return sprite;
		}
	}
}