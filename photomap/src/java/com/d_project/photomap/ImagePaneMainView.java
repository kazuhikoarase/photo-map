package com.d_project.photomap;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.Iterator;

import javax.imageio.ImageIO;

/**
 * ImagePaneMainView
 * @author Kazuhiko Arase
 */
@SuppressWarnings("serial")
class ImagePaneMainView extends ImageView {

    private ImagePane imagePane;
    private File file;

    public ImagePaneMainView(ImagePane imagePane) {
        
        this.imagePane = imagePane;
        this.file = null;

        setTransferHandler(new DnDEventTransferHandler() {

            protected boolean canExportEvent() {
                return false;
            }
            
            protected DnDEvent exportEvent() {
                return new DnDEvent(ImagePaneMainView.this, getFile() );
            }
            
            protected void importEvent(DnDEvent e) {
                try {
                    setFile( (File)e.getData() );
                } catch(IOException ie) {
                    ImagePaneMainView.this.imagePane.getMainFrame().handleException(ie);
                }
            }
        });
        
        DnDTrigger.attach(this);
        
    }

    public void setFile(File file) throws IOException {

        BufferedImage image = null;

        if (file != null) {
            image = ImageIO.read(file);
        }

        preSetFile();

        this.file = file;

        if (file != null) {
            imagePane.getMainFrame().getImageChooser().setSelectedFile(file);            
            imagePane.getMainFrame().setTitleIndirect(file.getPath() );
        } else {
            imagePane.getMainFrame().setTitleIndirect(null);
        }
        setImage(image);

        postSetFile();
    }
            
    public File getFile() {
        return file;
    }

    public String getRelativePath(File file) throws IOException {
        if (getFile() != null && file != null) {
            return FileUtil.getRelativePath(file, getFile().getParentFile() );
        } else {
            return null;
        }
    }

    public File getCanonicalFile(String path) throws IOException {
        if (getFile() != null && path.length() > 0) {
            return new File(file.getParentFile(), path).getCanonicalFile();
        }
        return null;
    }
 
    private void preSetFile() throws IOException {

        File file = getFile();
        
        if (file != null) {

            LinkData mainData = new LinkData(file);

            Iterator<String> names = imagePane.getEditPane().getValueNames().iterator();
            while (names.hasNext() ) {
                String name = names.next();
                mainData.setValue(name, imagePane.getEditPane().getValue(name) );
            }

            mainData.setValue(LinkData.Keys.LEFT,
                getRelativePath(imagePane.getLeftView().getFile() ) );
            mainData.setValue(LinkData.Keys.FRONT,
                getRelativePath(imagePane.getFrontView().getFile() ) );
            mainData.setValue(LinkData.Keys.RIGHT,
                getRelativePath(imagePane.getRightView().getFile() ) );

            mainData.save();

        }
    }    


    private void postSetFile() throws IOException {

        File file = getFile();
        
        File leftFile  = null;
        File frontFile = null;
        File rightFile = null;

        LinkData mainData = null;

        if (file != null) {
            mainData = new LinkData(file);
            leftFile  = getCanonicalFile(mainData.getValue(LinkData.Keys.LEFT) );
            frontFile = getCanonicalFile(mainData.getValue(LinkData.Keys.FRONT) );
            rightFile = getCanonicalFile(mainData.getValue(LinkData.Keys.RIGHT) );
        }

        imagePane.getLeftView().setFile(leftFile);
        imagePane.getFrontView().setFile(frontFile);
        imagePane.getRightView().setFile(rightFile);

        Iterator<String> names = imagePane.getEditPane().getValueNames().iterator();
        while (names.hasNext() ) {

            String name = names.next();

            if (mainData != null) {
                imagePane.getEditPane().setValue(name, mainData.getValue(name) );
            } else {
                imagePane.getEditPane().setValue(name, "");
            }
        }
    }    

}