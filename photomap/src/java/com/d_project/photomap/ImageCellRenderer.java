package com.d_project.photomap;

import java.awt.Component;
import java.io.File;
import java.io.IOException;

import javax.swing.DefaultListCellRenderer;
import javax.swing.ImageIcon;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.SwingConstants;

/**
 * ImageCellRenderer
 * @author Kazuhiko Arase
 */
@SuppressWarnings("serial")
public class ImageCellRenderer extends DefaultListCellRenderer {

    public ImageCellRenderer() {

    }
    
    public Component getListCellRendererComponent(
        JList list, Object value, int index, boolean selected, boolean cellHasFocus
    ) {
    
        JLabel label = (JLabel)super.getListCellRendererComponent(list, value, index,selected, cellHasFocus);

        try {

            LinkData linkData = new LinkData( (File)value);

            label.setIcon(new ImageIcon(linkData.getIconImage()) );
            label.setText(linkData.getFile().getName() );

            label.setHorizontalAlignment(SwingConstants.CENTER);
            label.setVerticalAlignment(SwingConstants.CENTER);
            label.setHorizontalTextPosition(SwingConstants.CENTER);
            label.setVerticalTextPosition(SwingConstants.BOTTOM);
               

        } catch(IOException e) {
        }
        
        return label;
    }

    
}
