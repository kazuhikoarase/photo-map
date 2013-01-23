package com.d_project.photomap;

import java.awt.Dimension;
import java.awt.Insets;
import java.awt.datatransfer.Transferable;
import java.io.File;
import java.io.IOException;

import javax.swing.ImageIcon;
import javax.swing.JComponent;
import javax.swing.JLabel;
import javax.swing.SwingConstants;

/**
 * ImagePaneIconView
 * @author Kazuhiko Arase
 */
@SuppressWarnings("serial")
class ImagePaneIconView extends JLabel {
    
    private ImagePane imagePane;
    private File file;
            
    public ImagePaneIconView(ImagePane imagePane) {

        this.imagePane = imagePane;        
        this.file = null;
        
        setHorizontalAlignment(SwingConstants.CENTER);
        setVerticalAlignment(SwingConstants.CENTER);
        setHorizontalTextPosition(SwingConstants.CENTER);
        setVerticalTextPosition(SwingConstants.BOTTOM);

        setTransferHandler(new DnDEventTransferHandler() {

            protected boolean canImportEvent() {
                return ImagePaneIconView.this.imagePane.getMainView().getFile() != null;
            }
            
            protected boolean canExportEvent() {
                return getFile() != null;
            }
            
            protected DnDEvent exportEvent() {
                return new DnDEvent(ImagePaneIconView.this, getFile() );
            }

            protected void exportDone(JComponent source, Transferable data, int action) {
                super.exportDone(source, data, action);
            }

            protected void importEvent(DnDEvent e) {

                if (e.getSource() instanceof ImagePaneIconView) {
                    // prevent move.
                    return;
                }

                try {
                    setFile( (File)e.getData() );
                } catch(IOException ie) {
                    ImagePaneIconView.this.imagePane.getMainFrame().handleException(ie);
                }
            }
        });
        
        DnDTrigger.attach(this);
    }
    
    public void setFile(File file) throws IOException {

        this.file = file;
        
        if (file != null) {
            setIcon(new ImageIcon(new LinkData(file).getIconImage() ) );
        } else {
            setIcon(null);
        }

        setText(imagePane.getMainView().getRelativePath(file) );

    }
    
    public File getFile() {
        return file;
    }

    public Dimension getPreferredSize() {
        Insets insets = getInsets();
        return new Dimension(
            130 + insets.left + insets.right,
            120 + insets.top + insets.bottom);
    }
} 