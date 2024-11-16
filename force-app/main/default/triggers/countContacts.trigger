trigger countContacts on contact (After insert, After update, After delete, After undelete) {
    Set<Id> accIds = new Set<Id>();
    if(Trigger.isAfter && (trigger.isInsert || trigger.isUndelete)){
        if(!trigger.new.isEmpty()){
             for(contact con : trigger.new){
                if(con.accountId != null){
                    accIds.add(con.accountId);                }
             }
        }
    }
    if(Trigger.isAfter && trigger.isDelete){
        if(!trigger.old.isEmpty()){
            for(contact con : trigger.old){
                if(con.AccountId != null){
                    accIds.add(con.AccountId);
                }
            }
        }
    }

    if(Trigger.isAfter && Trigger.isUpdate){
        if(!trigger.new.isEmpty()){
            for(Contact con : Trigger.new){
                if(con.AccountId != null && con.AccountId != trigger.oldMap.get(con.Id).AccountId){
                    accIds.add(con.AccountId);
                    accIds.add(trigger.oldMap.get(con.Id).AccountId);
                }else{
                    accIds.add(con.AccountId);
                }
            }
        }
    }

    if(!accIds.isEmpty()){
        List<Account> accList = new List<Account>();
        List<Account> ListToUpdate = new List<Account>();
         accList = [Select Id, Name, CountOfContacts__c, (Select Id, LastName from Contacts) from Account where Id in : accIds];
         if(!accList.isEmpty()){
            for(Account acc : accList){
                acc.CountOfContacts__c = acc.contacts.size();
                ListToUpdate.add(acc);
            }
         }
         if(ListToUpdate.size() > 0){
            try{
                update ListToUpdate;
            }catch(DmlException e){
                system.debug('Error occured while updating the contact  count:'+ e.getMessage());
            }
            
         }
    }
}