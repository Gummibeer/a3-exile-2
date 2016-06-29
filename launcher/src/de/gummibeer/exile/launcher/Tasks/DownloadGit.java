package de.gummibeer.exile.launcher.Tasks;

import de.gummibeer.exile.launcher.Contracts.Task;
import de.gummibeer.exile.launcher.Launcher;
import org.apache.commons.compress.archivers.tar.TarArchiveEntry;
import org.apache.commons.compress.archivers.tar.TarArchiveInputStream;
import org.apache.log4j.Logger;

import java.io.*;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.zip.GZIPInputStream;

public class DownloadGit implements Task {
    private static Logger logger = Logger.getLogger(DownloadGit.class);

    private static String token = "QpxEKjL5sPJUkN2J7uaG";
    private static String branch = "master";

    public static boolean run() {
        logger.info("Start Task: DownloadGit");

        try {
            branch = Launcher.getConfig("branch");
            String uri = "https://gitlab.com/api/v3/projects/1319634/repository/archive?sha=" + branch + "&private_token=" + token;
            logger.debug("download archive");
            URL url = new URL(uri);
            URLConnection connection = url.openConnection();
            InputStream in = connection.getInputStream();
            FileOutputStream out = new FileOutputStream(branch + ".tar.gz");
            byte[] b = new byte[1024];
            int count;
            while ((count = in.read(b)) >= 0) {
                out.write(b, 0, count);
            }
            out.flush();
            out.close();
            in.close();

            logger.debug("extract archive");
            File archive = new File(branch + ".tar.gz");
            TarArchiveInputStream tarInput = new TarArchiveInputStream(new GZIPInputStream(new FileInputStream(branch + ".tar.gz")));
            TarArchiveEntry entry;
            FileOutputStream outputFile;
            int offset;
            while ((entry = tarInput.getNextTarEntry()) != null) {
                String fileName = archive.getName().substring(0, archive.getName().lastIndexOf('.'));
                fileName = fileName.substring(0, fileName.lastIndexOf('.'));
                logger.debug("extract: " + entry.getName());
                File outputDir = new File(fileName + "/" + entry.getName());
                if (!outputDir.getParentFile().exists()) {
                    outputDir.getParentFile().mkdirs();
                }
                //if the entry in the tar is a directory, it needs to be created, only files can be extracted
                if (entry.isDirectory()) {
                    outputDir.mkdirs();
                } else {
                    byte[] content = new byte[(int) entry.getSize()];
                    offset = 0;
                    tarInput.read(content, offset, content.length - offset);
                    outputFile = new FileOutputStream(outputDir);
                    outputFile.write(content);
                    outputFile.close();
                }
            }
        } catch (MalformedURLException exception) {
            logger.error(exception.getMessage());
            return false;
        } catch (FileNotFoundException exception) {
            logger.error(exception.getMessage());
            return false;
        } catch (IOException exception) {
            logger.error(exception.getMessage());
            return false;
        }

        return true;
    }
}
