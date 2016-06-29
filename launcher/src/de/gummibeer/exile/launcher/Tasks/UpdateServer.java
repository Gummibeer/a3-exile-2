package de.gummibeer.exile.launcher.Tasks;

import de.gummibeer.exile.launcher.Contracts.Task;
import de.gummibeer.exile.launcher.Launcher;
import org.apache.log4j.Logger;

import java.io.IOException;

public class UpdateServer implements Task {
    private static Logger logger = Logger.getLogger(UpdateServer.class);

    public static boolean run() {
        logger.info("Start Task: UpdateServer");
        if (System.getProperty("os.name").toLowerCase().contains("windows")) {
            try {
                logger.debug("update arma3server.exe");
                Runtime rt = Runtime.getRuntime();
                String armaUpdate = Launcher.getConfig("steamcmd") +
                        " +login " + Launcher.getConfig("steamlogin") +
                        " +force_install_dir " + Launcher.getConfig("armafolder") +
                        " +\"app_update " + Launcher.getConfig("armabranch") + "\"" +
                        " validate +quit";
                logger.debug(armaUpdate);
                rt.exec(armaUpdate);
                logger.debug("updated arma3server.exe");
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
