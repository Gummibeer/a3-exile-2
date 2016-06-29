package de.gummibeer.exile.launcher.Tasks;

import de.gummibeer.exile.launcher.Contracts.Task;
import de.gummibeer.exile.launcher.Launcher;
import org.apache.log4j.Logger;

import java.io.IOException;

public class PackPbos implements Task {
    private static Logger logger = Logger.getLogger(PackPbos.class);

    public static boolean run() {
        logger.info("Start Task: PackPbos");
        if (System.getProperty("os.name").toLowerCase().contains("windows")) {
            try {
                logger.debug("pack all pbos");
                Runtime rt = Runtime.getRuntime();
                // ToDo: create pack command and loop generic over all needed
                String packPbo = "";
                logger.debug(packPbo);
                rt.exec(packPbo);
                logger.debug("packed all pbos");
            } catch (IOException ex) {
                logger.error(ex.getMessage());
                return false;
            }
        } else {
            logger.warn("unsupported OS");
            return false;
        }
        return true;
    }
}
