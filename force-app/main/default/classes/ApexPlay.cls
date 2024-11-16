public class ApexPlay {
    
    public static void listMapPlay(){
    	List<Account> accList = new List<Account>();
    	accList = [Select Id, Name, Phone from Account where billingCountry = 'USA'];
    	map<Id,Account> accMap = new map<Id,Account>();
        for(Account acc : accList){
            accMap.put(acc.Id, acc);
        }
        system.debug(accMap);
    }
	
}