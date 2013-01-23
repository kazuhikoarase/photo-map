package com.d_project.photomap {

    import flash.events.Event;
    
    /**
     * PhotoMapEvent
     * @author Kazuhiko Arase
     */
    public class PhotoMapEvent extends Event {

        public static const LOAD_COMPLETE : String = "loadComplete";

        public static const WALK_COMPLETE : String = "walkComplete";

        public function PhotoMapEvent(type : String) {
            super(type);
        }
        
        public override function clone() : Event {
            return new PhotoMapEvent(type);
        }
    }
}