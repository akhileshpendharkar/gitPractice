public with sharing class GlobalWarmingRestApi {
    
    public static void globalWarmingApi(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://global-warming.org/api/temperature-api');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200){
            System.debug('Made a callout '+ response.getBody());
        } 
    }
}