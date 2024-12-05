@RestResource (Urlmapping='/AccountContactApi')
global with sharing class AccountContactRestApi {
    @httpPost
    global static void savedAccContactFromExtSys(){
        Rest req = RestContext.request;
        RestResponse res = RestContext.response;

        String body = req.resquestBody.toString();//{"CustomerName": "Akhi", "isAccount":""true}
        MyAccountContactWrapper accConWrap = (MyAccountContactWrapper) JSON.deserialize(body,MyAccountContactWrapper.class);

        System.debug(''+accConWrap.CustomerName);
        System.debug(''+accConWrap.isAccount);
        

        if(accConWrap.isAccount){
            Account acc = new Account();
            acc.Name = accConWrap.CustomerName;
            insert acc;
        }else if{
            Contact con = new Contact();
            con.LastName = accConWrap.CustomerName;
            insert con;
        }
    
    }
}