package de.gummibeer.exile.launcher.Tasks;

import de.gummibeer.exile.launcher.Contracts.Task;
import de.gummibeer.exile.launcher.Launcher;
import org.apache.commons.compress.archivers.tar.TarArchiveEntry;
import org.apache.commons.compress.archivers.tar.TarArchiveInputStream;
import org.apache.log4j.Logger;

import java.io.*;
import java.util.zip.GZIPInputStream;

public class ExtractGit implements Task {
    private static Logger logger = Logger.getLogger(ExtractGit.class);

    private static String branch = "master";

    public static boolean run() {
        logger.info("Start Task: ExtractGit");

        try {
            branch = Launcher.getConfig("branch");
            logger.debug("extract archive");
            File archive = new File(branch + ".tar.gz");
            TarArchiveInputStream tarInput = new TarArchiveInputStream(new GZIPInputStream(new FileInputStream(branch + ".tar.gz")));
            TarArchiveEntry entry;
            FileOutputStream outputFile;
            int offset;
            String fileName = archive.getName().substring(0, archive.getName().lastIndexOf('.'));
            fileName = fileName.substring(0, fileName.lastIndexOf('.'));
            while ((entry = tarInput.getNextTarEntry()) != null) {
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
            CopyGit.source = new File(fileName).getAbsolutePath();
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
