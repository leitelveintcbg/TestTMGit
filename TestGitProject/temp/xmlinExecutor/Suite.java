package xmlinExecutor;
//File:Suite
import java.rmi.RemoteException;
import hu.fot.testManager.core.transactor.*;
import hu.fot.testManager.core.Master;
import hu.fot.testManager.core.selector.*;
import hu.fot.testManager.core.datapool.*;
import hu.fot.testManager.core.synchronizationPoint.*;

@SuppressWarnings("unused")
public abstract class Suite {

	

    public static void createDatapools(java.util.HashMap<String, Datapool> map, String rootPath, String defaultPackage, Master master) throws Exception
    {
		

    }

    public static void createLocalDatapools(java.util.HashMap<String, Datapool> map, Master master) throws RemoteException, DatapoolCreateException
    { //does nothing
    
    
    			
    
    }		



    public static void createTransactors(java.util.HashMap<String, Transactor> map, Master theMaster) throws RemoteException, DatapoolCreateException
    {
		
    }


    public static void createSynchronizationPoints(java.util.HashMap<String, hu.fot.testManager.core.synchronizationPoint.SynchronizationPoint> map) throws RemoteException
    {
		
    }



    public static void createRandomSelectors(java.util.HashMap<String, hu.fot.testManager.core.selector.DefaultRandomSelector> map) throws Exception
    {
	
    }

}
//EndFile:Suite