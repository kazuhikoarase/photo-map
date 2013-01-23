package com.d_project.photomap;

import javax.swing.JComponent;

/**
 * DnDEvent
 * @author Kazuhiko Arase
 */
public class DnDEvent {
    
    private JComponent source;
    private Object data;
    
    public DnDEvent(JComponent source, Object data) {
        this.source = source;
        this.data = data;
    }
    
    public JComponent getSource() {
        return source;
    }
    
    public Object getData() {
        return data;
    }
    
    
}
