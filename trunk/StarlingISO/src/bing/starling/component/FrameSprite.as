package bing.starling.component
{
    import starling.core.Starling;
    import starling.display.MovieClip;
    import starling.display.Sprite;

    public class FrameSprite extends Sprite
    {
        private var mFrames:Vector.<MovieClip> = new <MovieClip>[];
        private var mCurrentFrame:int = 1;
        private var mCurrentLabel:String;
        private var mFramesCount:int = 1;
        private var mPaused:Boolean = false;

        public function FrameSprite()
        {
            super();
        }

        public function addFrame(mFrame:MovieClip, label:String):void
        {
            mFrame.name = label;
            mFrames.push(mFrame);
            addChild(mFrame);
                Starling.juggler.add(mFrame);
            if (mFramesCount++ == 1) {
                mCurrentLabel = label;
            } else {
                mFrame.visible = false;
            }
        }

        public function removeFrame(_val:*):void
        {
            var mTempFrame:MovieClip;
            var mFrame:MovieClip;

            for (var i:int = 0; i < mFramesCount; i++) {
                mTempFrame = mFrames[i];
                if (mTempFrame.name == _val) {
                    mFrame = mTempFrame;
                    mCurrentFrame = i+1;
                    break;
                }
            }

            if (!mFrame) mFrame = mFrames[_val-1];

            if (_val == mCurrentFrame) prevFrame();

            if (mFrame) {
                removeChild(mFrame);
                Starling.juggler.remove(mFrame);
                mFrames.splice(_val-1,1);
                mFramesCount--;
            }
        }

        public function nextFrame():void
        {
            play(mCurrentFrame+1);
        }

        public function prevFrame():void
        {
            play(mCurrentFrame-1);
        }

        public function getCurrentFrameMovieClip():MovieClip
        {
            return (mCurrentFrame >= 1 && mCurrentFrame <= mFramesCount) ? mFrames[mCurrentFrame-1] : null;
        }

        public function play(_val:*):void
        {
            if (mCurrentLabel == _val || mCurrentFrame == _val) return;

            var mFrame:MovieClip = null;
            var mTempFrame:MovieClip = null;
            var prevFrame:Number = mCurrentFrame;

            for (var i:uint = 0; i < mFramesCount; i++) {
                mTempFrame = mFrames[i];
                if (mTempFrame.name == _val) {
                    mFrame = mTempFrame;
                    mCurrentFrame = i+1;
                    break;
                }
            }

            if (!mFrame) {
                mCurrentFrame = _val;
                mFrame = mFrames[_val-1];
            }

            if (mFrame) {
                mCurrentLabel = mFrame.name;

                mTempFrame = mFrames[prevFrame-1];
                mTempFrame.stop();
                mTempFrame.visible = false;

                mFrame.currentFrame = 0;
                mFrame.visible = true;
                mFrame.play();
            }
        }

        public function stop():void
        {
            var mFrame:MovieClip = getCurrentFrameMovieClip();
            if (mFrame) mFrame.stop();
        }

        public function pauseOrResume():void
        {
            mPaused = !mPaused;
            var mFrame:MovieClip = getCurrentFrameMovieClip();
            if (mFrame) {
                if (mPaused) mFrame.pause(); else mFrame.play();
            }
        }

        public function getCurrentFrame():Number
        {
            return mCurrentFrame;
        }

        public function getCurrentFrameLabel():String
        {
            return mCurrentLabel;
        }

        public function setCurrentFrame(_val:Number):void
        {
            if (_val < 1) _val = 1;
            if (_val > mFramesCount) _val = mFramesCount;
            mCurrentFrame = _val;
        }

        public function getTotalFrames():Number
        {
            return mFramesCount;
        }

        public function destroy():void
        {
            var mTempFrame:MovieClip;

            for (var i:int = 0; i < mFramesCount; i++) {
                mTempFrame = mFrames[i];
                if (mTempFrame) {
                    removeChild(mTempFrame);
                    Starling.juggler.remove(mTempFrame)
                    mTempFrame.dispose();
                    mTempFrame = null;
                }
            }

            mFrames.length = 0;
        }
    }
}