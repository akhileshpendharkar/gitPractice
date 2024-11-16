trigger AddressChangeHistory on Account (After Insert, After Update){
    List<Address_History__c> addressHistoryList = new List<Address_History__c>();
    if(trigger.isAfter && (trigger.isInsert  || trigger.isUpdate)){
        if(!trigger.new.isEmpty()){
            for(Account acc : trigger.new){
                if(acc.BillingCity != trigger.oldMap.get(acc.Id).BillingCity || 
                   acc.BillingCountry != trigger.oldMap.get(acc.Id).BillingCountry || 
                   acc.BillingState != trigger.oldMap.get(acc.Id).BillingState ||
                   acc.BillingCountry != trigger.oldMap.get(acc.Id).BillingCountry ||
                   acc.BillingPostalCode != trigger.oldMap.get(acc.Id).BillingPostalCode||
                   acc.BillingStreet != trigger.oldMap.get(acc.Id).BillingStreet
                ){
                    Address_History__c ah = new Address_History__c();
                    ah.Account__c = acc.Id;
                    ah.City__c = acc.BillingCity;
                    ah.Country__c = acc.BillingCountry;
                    ah.State__c = acc.BillingState;
                    ah.Street_Name__c  = acc.BillingStreet;
                    ah.Postal_Code__c = acc.BillingPostalCode;
                    ah.Date_Changed__c  = Date.Today();
                    ah.Time_Changed__c = Datetime.now().time();
                    addressHistoryList.add(ah);
                }
            }
            if(!addressHistoryList.isEmpty()){
                try{
                    insert addressHistoryList;
                }catch(DmlException e){
                    System.debug('Address History Insert Failed :' + e);
                }
            }
                
            
        }
    }
     
}