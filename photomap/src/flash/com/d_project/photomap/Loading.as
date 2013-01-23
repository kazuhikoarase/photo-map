package com.d_project.photomap {

    import flash.events.Event;
    import flash.text.TextField;
    import flash.text.TextFormat;

    /**
     * Loading
     * @author Kazuhiko Arase
     */
    public class Loading extends TextField {

        private var _step : int;

        private var _status : String;
        
        public function Loading() {
            
            _step = 0;
            _status = Status.STOP;
            
            defaultTextFormat = new TextFormat("_sans", 14, 0x666666);
            text = "Loading...";

            addEventListener(Event.ENTER_FRAME, enterFrameHandler);
        }

        public function start() : void {
            alpha = 0;
            _step = 0;
            _status = Status.FADE_IN_DELAY;
        }
        
        public function stop() : void {
            _status = Status.STOP;
        }
        
        private function enterFrameHandler(event : Event) : void {

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
