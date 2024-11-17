trigger OpportunityAccountsTrigger on Account (after insert) {

    List<Opporunity> oppsToInsert = new List<Opportunity>();
    if(!Trigger.new.isEmpty() && Trigger.isAfter && Trigger.isInsert){
        for(Account acc : Trigger.new){
            if(acc.NumberOfEmployees > 0 && acc.NumberOfEmployees < 1000){
                for(Integer i=0 ; i< acc.NumberOfEmployees; i++){
                    Opportunity opp = new Opportunity();
                    opp.AccountId = acc.Id;
                    opp.Name = acc.Name + i;
                    opp.StageName = 'Prospecting';
                    opp.CloseDate = System.today().addDays(15);
                    oppsToInsert.add(opp);
                }
                
            }
            if(oppsToInsert.size() > 0){
                insert oppsToInsert;
            }
        }
    }
}

