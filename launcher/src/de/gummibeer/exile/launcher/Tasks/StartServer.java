package de.gummibeer.exile.launcher.Tasks;

import de.gummibeer.exile.launcher.Contracts.Task;
import org.apache.log4j.Logger;

public class StartServer implements Task {
    private static Logger logger = Logger.getLogger(StartServer.class);

    public static boolean run() {
        logger.info("Start Task: StartServer");
        return true;
    }
}
