package com.d_project.photomap;

import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.UnsupportedFlavorException;
import java.io.IOException;

import javax.swing.JComponent;
import javax.swing.TransferHandler;

/**
 * DnDEventTransferHandler
 * @author Kazuhiko Arase
 */
@SuppressWarnings("serial")
public abstract class DnDEventTransferHandler extends TransferHandler {

    private static final DataFlavor DnDEventFlavor;
    
    static {
        DnDEventFlavor = new DataFlavor(
            DataFlavor.javaJVMLocalObjectMimeType,
            ";class=" + DnDEvent.class.getName() );
    }

    
    public DnDEventTransferHandler() {
    }


// implementation for import. (drop)

    public boolean canImport(JComponent comp, DataFlavor[] transferFlavors) {

        for (int i = 0; i < transferFlavors.length; i++) {
            if (transferFlavors[i].equals(DnDEventFlavor) ) {
                return canImportEvent();
            }
        }
        
        return false;
    }

    public boolean importData(JComponent comp, Transferable t) {

        try {
            importEvent( (DnDEvent)t.getTransferData(DnDEventFlavor) );        
            return true;

        } catch(Exception e) {
        }

        return false;
    }

// implementation for export. (drag)

    public int getSourceActions(JComponent comp) {
        return canExportEvent()? COPY_OR_MOVE : NONE;
    }
    
    protected Transferable createTransferable(JComponent comp) {
        return new DnDEventFileTransferable(exportEvent() );
    }


///////// implement.
    
    protected boolean canImportEvent() {
        return true;
    }

    protected boolean canExportEvent() {
        return true;
    }
    
    protected abstract void importEvent(DnDEvent e);
    protected abstract DnDEvent exportEvent();

    private static class DnDEventFileTransferable implements Transferable {

        private DnDEvent e;
        
        private DnDEventFileTransferable(DnDEvent e) {
            this.e = e;
        }
        
        public Object getTransferData(DataFlavor flavor)
        throws UnsupportedFlavorException, IOException {
            if (!flavor.equals(DnDEventFlavor) ) {
                throw new UnsupportedFlavorException(flavor);
            }
            return e;
        }

        public DataFlavor[] getTransferDataFlavors() {
            return new DataFlavor[] {DnDEventFlavor};
        }
        
        public boolean isDataFlavorSupported(DataFlavor flavor) {
            return DnDEventFlavor.equals(flavor);
        }
    }
}
