public class GoogleSearch {
    
    global static string googleMe(String query){
        String endpoint = 'https://www.google.com/search?q='+query;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        HTTPResponse response = http.send(request);

        if(response.getStatusCode() == 200){
            return response.getBody();
        }
        return null;
        

    }
}