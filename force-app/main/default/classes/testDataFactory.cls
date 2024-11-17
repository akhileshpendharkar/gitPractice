@isTest
public class TestDataFactory{
    public static Account getAccount(String name){
        Account acc = new Account();
        acc.Name = 'Test Account';
        return acc;
    }

    public static Contact getContact(String lname){
        Account a = getAccount('test');
        Contact c = new Contact();
        c.AccountId = a.Id;
        c.LastName = lname;
        insert c;
        return c;
        
    }

    public static void accountWithContact(Integer numberOfContacts){
        Account a = getAccount('Account with multiple Contacts');
        List<Contact> con = new List<Contact>();
        for(Integer i=0; i<numberOfContacts; i++){
            Contact c = new Contact();
            c.AccountId = a.Id;
            c.LastName = 'Test'+i;
            con.add(c);
        }
        insert con;
    }

    public static List<Opportunity> getOpportunities(Decimal amount, Integer numberOfOpportunities){
        Account a = getAccount('Test Opportunity');
        List<Opportunity> o = new List<Opportunity>();
        for(Integer i=0; i<NumberOfOpportunities;i++){
            Opportunity opp = new Opportunity();
            opp.AccountId = a.Id;
            opp.Amount = amount;
            opp.Name = 'Test'+i;
            opp.stageName = 'Prospecting';
            opp.CloseDate = System.today().addDays(15);
            o.add(opp);
        }
        insert o;
        return 0;

    }

}