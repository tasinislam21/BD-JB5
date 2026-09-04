package debug;

public class test {
	
	public static String fibonacciNumber() {
	    int first = 0;
	    int second = 1;
	    String[] results = new String[10];

	    for (int i = 0; i < 10; i++) {
	        results[i] = String.valueOf(first);

	        int next = first + second;
	        first = second;
	        second = next;
	    }

	    return String.join(" ", results);
	}
	

    public static void main(String[] args) {
    	System.out.println(fibonacciNumber());
    	Class<?> clazz = null;
        try {
        	clazz = Class.forName("sun.launcher.LauncherHelper");
            System.out.println("Success! Returned object: " + clazz);
        } catch (Throwable e) {
            System.out.println("Failed! The class does not exist or cannot be accessed.");
            
        }
    	SecurityManager sm = new SecurityManager();
    	SecurityManager sm1 = new SecurityManager();
    	System.setSecurityManager(sm);
        try {
        	if (sm == null) {
                System.out.println("No Security Manager");
            }
        	else {
                System.out.println("Security Manager still working!");
                sm.checkPackageAccess("sun.launcher.LauncherHelper");
        	}
        	
        }
        catch (SecurityException e) {
        	System.out.println("SM cannot access sun.launcher.LauncherHelper");
        
        }
    }
}