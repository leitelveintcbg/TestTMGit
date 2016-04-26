package xmlinExecutor;
//File:VirtualUserGroupUserGroup

import hu.fot.testManager.core.VirtualUserData;
import java.rmi.RemoteException;
import hu.fot.testManager.core.DefaultVirtualUser;
import hu.fot.testManager.core.UserGroup;
import hu.fot.testManager.core.scripts.Script;
import hu.fot.testManager.core.exceptions.ScriptStopped;

@SuppressWarnings({ "unused", "serial" })
public class VirtualUserGroupUserGroup extends DefaultVirtualUser {

    public VirtualUserGroupUserGroup(UserGroup ug, int un) throws RemoteException
    {
        super(ug,un);
    }

    public void run()
    {
        try {
            state = VirtualUserData.OVERHEAD;
            setCommand("Begining the script");
            java.util.Random random = new java.util.Random();

            random.setSeed(System.currentTimeMillis()*userNumber);

            int usersInGroup = getUserNumberInGroup();
executeScript("hu.fot.testManager.core.scripts.BusinessProcessExecutor", "BusinessProcessExecutor", 1, false, null);
executeScript("hu.fot.testManager.globus.scripts.CloseSessions", "Close Globus Sessions", 1, false, null);

	    } catch (ScriptStopped e) {
	    } catch (Exception e) {
	        try {
		    	setMessage("Fatal error: "+e);
        	
        		StackTraceElement[] ste = e.getStackTrace();
				for (int i = 0; i < ste.length; i++) {
					testcase(Script.FAILED, ste[i].toString().replaceAll("&", "&").replaceAll("<", "&lt;").replaceAll(">", "&gt;"), "");
				}
			
		    } catch (RemoteException e1) {
        	}

        } finally {
	    	state = VirtualUserData.STOPPED;
	        command = "";
	        scriptName = "";
	        setVirtualUserData();
        }
    }
}
//EndFile:VirtualUserGroupUserGroup