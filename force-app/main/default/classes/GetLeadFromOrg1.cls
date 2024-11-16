@RestResource(urlMapping='/v1/GetLeadFromOrg1/*')
global class GetLeadFromOrg1 {
	@Httppost
    global static String saveLead(){
        String requestBody;
        RestRequest req = RestContext.request;
        requestBody = RestContext.request.requestBody.toString();
        System.debug(requestBody);
        List<Lead> leadList = (List<Lead>) System.JSON.deserialize(requestBody,List<Lead>.class);
        System.debug(leadList);
        for(Lead lead: leadList){
            lead.Id = null;
        }
        try{
            insert leadList;
            system.debug('Lead Inserted');
            return 'Record Inserted';
        }
        catch(exception e){
            return e.getMessage();
        }
    }
}