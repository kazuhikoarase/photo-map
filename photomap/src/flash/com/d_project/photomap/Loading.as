package com.d_project.photomap {

    import flash.events.Event;
    import flash.text.TextField;
    import flash.text.TextFormat;

    /**
     * Loading
     * @author Kazuhiko Arase
     */
    public class Loading extends TextField {

        /**
         * 下記のパスにフォントが存在しない場合は、適宜修正が必要
         */
        [Embed(source="C:\\WINDOWS\\Fonts\\verdana.ttf",
			fontFamily="Verdana",
			unicodeRange="U+002E,U+004C,U+0061,U+0064,U+0067,U+0069,U+006E,U+006F")]

        private static var fontVerdana : Class;

        private var _step : int;

        private var _status : String;
        
        public function Loading() {
            
            _step = 0;
            _status = Status.STOP;
            
            defaultTextFormat = new TextFormat("Verdana", 14, 0x666666);
            embedFonts = true;
            text = "Loading...";

            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }

        public function start() : void {
            alpha = 0;
            _step = 0;
            _status = Status.FADE_IN_DELAY;
        }
        
        public function stop() : void {
            _status = Status.STOP;
        }
        
        private function onEnterFrame(e : Event) : void {

            switch(_status) {

            case Status.STOP :
                _step = 0;
                alpha = 0;
                break;

            case Status.FADE_IN_DELAY :
                _step++;
                if (_step >= 20) {
                    _step = 0;
                    _status = Status.FADE_IN;
                }
                break;

            case Status.FADE_IN :
                _step++;
                if (_step >= 10) {
                    _step = 10;
                    _status = Status.FADE_OUT;
                }
                alpha = _step / 10;
                break;

            case Status.FADE_OUT :
                _step--;
                if (_step <= 0) {
                    _step = 0;
                    _status = Status.FADE_IN;
                }
                alpha = _step / 10;
                break;
            }
        }        
    }
}

final class Status {

    public static const STOP : String = "stop";

    public static const FADE_IN_DELAY : String = "fadeInDelay";

    public static const FADE_IN : String = "fadeIn";

    public static const FADE_OUT : String  = "fadeOut";
}
