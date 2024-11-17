@isTest
public with sharing class OpportunityAccountsTriggerTest {
    @TestSetup
    static void accountSetup(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.NumberOfEmployees = 10;
        insert acc; 
    }

    @isTest
    public static void testOpportunities(){
        Account getAccount = [Select Id, NumberOfEmployees, (Select Id from Opportunities) from Account where Name = 'dummy'];
        system.assertEquals(getAccount.Opportunities.size(), 10, 'Check for size of the opportunity');
    }
        
}

