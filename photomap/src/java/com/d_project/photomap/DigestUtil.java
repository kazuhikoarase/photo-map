package com.d_project.photomap;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.security.MessageDigest;

/**
 * DigestUtil
 * @author Kazuhiko Arase
 */
public class DigestUtil {
    
    private DigestUtil() {
    }

    public static String getDigest(File file) {

        try {

            int bufsize = 1024;

            InputStream in = new BufferedInputStream(new FileInputStream(file), bufsize);

            try {

                MessageDigest md = MessageDigest.getInstance("MD5");
        
                byte[] buf = new byte[bufsize];
                int len = 0;

                while ( (len = in.read(buf) ) != -1) {
                    md.update(buf, 0, len);
                }
                
                return toHexString(md.digest() );

            } finally {
                in.close();
            }

        } catch(Exception e) {
            throw new Error(e);
        }
    }
    

    private static char toHexString(int num) {
        if (0 <= num && num < 10) {
            return (char)('0' + num);
        } else if (10 <= num && num < 16) {
            return (char)('A' + num - 10);
        } else {
            throw new Error();
        }
    }

    private static String toHexString(byte[] b) {
        char[] hexChars = new char[b.length * 2];
        for (int i = 0; i < b.length; i++) {
            hexChars[i * 2] = toHexString( (b[i] >>> 4) & 0x0f);
            hexChars[i * 2 + 1] = toHexString(b[i] & 0x0f);
        }
        return new String(hexChars);
    }
}
