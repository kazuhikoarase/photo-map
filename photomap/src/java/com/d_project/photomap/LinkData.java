package com.d_project.photomap;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.SAXException;

/**
 * LinkData
 * @author Kazuhiko Arase
 */
class LinkData  {

    public interface Keys  {
        String DIGEST   = "digest";
        String LEFT     = "left";
        String FRONT    = "front";
        String RIGHT    = "right";
    }

    private final File file;
    private final Map<String, String> values;
    private boolean updated;
    private boolean silent;

    public LinkData(File file) throws IOException {

        this.file = file;
        this.values = new HashMap<String, String>();
        this.updated = false;

        silent = true;

        try {
            // init

			setValue("name", file.getName() );
/*
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy/M/d H:mm");
	        Date date = new Date(file.lastModified() );
	        setValue("date", formatter.format(date).toString() );
*/

            if (getLinkFile().exists() ) {
                load();
            }

        } finally {
            silent = false;
        }        
    }


    public void resizeImage() throws IOException {

        int height = 480;
    
        BufferedImage image = ImageIO.read(file);
        
        if (image.getHeight() > height) {
        
            File tmpFile = null;
            
            int num = 1;
            String date = new SimpleDateFormat("yyyyMMdd").format(new Date() );
        
            do {
                tmpFile = new File(file.getParent(), 
                    file.getName() + "." + date + "." + num++ + ".bak");
            } while (tmpFile.exists() );
        
            if (!file.renameTo(tmpFile) ) {
                throw new IOException("fail to rename:" + tmpFile);
            }
        
            ImageUtil.createImage(tmpFile, file, height);
        }

        updateIconImage();
    }

    public void updateIconImage() throws IOException {

        String digest = DigestUtil.getDigest(getFile() );
        
        boolean digestChanged = !digest.equals(getValue(Keys.DIGEST) );
        
        if (digestChanged) {
            setValue(Keys.DIGEST, digest);
            save();
        }

        if (digestChanged || !getIconFile().exists() ) {
            ImageUtil.createImage(getFile(), getIconFile(), 90);
        }
    }
        
        
    public Image getIconImage() throws IOException {

        if (isImageLock() ) {
            
            BufferedImage image = new BufferedImage(120, 90, BufferedImage.TYPE_INT_RGB);
            Graphics g = image.getGraphics();
            g.setColor(Color.lightGray);
            g.fillRect(0, 0, 120, 90);
            
            return image;
        }

        updateIconImage();

        return ImageIO.read(getIconFile() );
    }
        
    public File getLinkFile() {
        return new File(file.getParentFile(), file.getName() + ".xml");
    }             
    
    public File getFile() {
        return file;
    }             

    public File getIconFile() {
        return new File(new File(file.getParentFile(), ".cache"), file.getName() );
    }             
    
    public void setUpdated(boolean updated) {
        this.updated = updated;
    }
    
    public boolean isUpdated() {
        return updated;
    }

    public boolean save() throws IOException {

        if (!isUpdated() ) {
            return false;
        }
               
        try {

            Document document = DocumentBuilderFactory.newInstance()
                .newDocumentBuilder().newDocument();

            Node photomapNode = document.appendChild(document.createElement("photomap") );

            Object[] names = values.keySet().toArray();
            Arrays.sort(names);

            for (int i = 0; i < names.length; i++) {
                String name = (String)names[i];
                appendNodeText(photomapNode, name, getValue(name) );
            }

            Transformer trans = TransformerFactory.newInstance().newTransformer();
            trans.transform(new DOMSource(document), new StreamResult(getLinkFile() ) );
            
            setUpdated(false);

            return true;
            
        } catch(TransformerException e) {
            throw new Error(e);
        } catch(ParserConfigurationException e) {
            throw new Error(e);
        }
    }
    
    private void load() throws IOException {

        try {

            Document document = DocumentBuilderFactory.newInstance()
                .newDocumentBuilder().parse(getLinkFile() );
            Node photomapNode = document.getDocumentElement();

            for (int i = 0; i < photomapNode.getChildNodes().getLength(); i++) {
                Node node = photomapNode.getChildNodes().item(i);
                if (node.getNodeType() == Node.ELEMENT_NODE) {
                    setValue(node.getNodeName(), getNodeText(node) );
                } 
            }
                    
        } catch(ParserConfigurationException e) {
            throw new Error(e);
        } catch(SAXException e) {
            throw new Error(e);
        }
    }

    public void setValue(String name, String value) {
        
        value = (value != null)? value : "";

        if (!getValue(name).equals(value) ) {

            values.put(name, value);

            if (!silent) {
                setUpdated(true);
            }
        }
    }
    
    public String getValue(String name) {
        String value = (String)values.get(name);
        return (value != null)? value : "";
    }
    
    private static void appendNodeText(Node node, String name, String value) {
        if (value != null && value.length() > 0) {
            Document document = node.getOwnerDocument();
            node.appendChild(document.createElement(name) ).appendChild(document.createTextNode(value) );
        }
    }
    
    private static String getNodeText(Node parentNode) {

        StringBuffer buffer = new StringBuffer();

        for (int i = 0; i < parentNode.getChildNodes().getLength(); i++) {
            Node node = parentNode.getChildNodes().item(i);
            if (node.getNodeType() == Node.TEXT_NODE) {
                buffer.append(node.getNodeValue() );
            } 
        }

        return buffer.toString();
    }
    
    private static boolean imageLock;
    
    private static final Object LOCK = new Object();
    
    public static void setImageLock(boolean imageLock) {
        synchronized(LOCK) {
            LinkData.imageLock = imageLock;
        }
    }

    public static boolean isImageLock() {
        synchronized(LOCK) {
            return imageLock;
        }
    }
}
