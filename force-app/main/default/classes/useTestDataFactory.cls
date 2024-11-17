@isTest
public class UseTestDataFactory {
    @isTest
    static void getResults(){
        Account a = testDataFactory.getAccount('Programming');
        system.assertEquals(a.Name, 'Programming', 'Its working');
    
    }
}