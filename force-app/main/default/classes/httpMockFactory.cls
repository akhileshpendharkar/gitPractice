@isTest
public class HttpCalloutMock implements httpMockFactory {
    protected Integer code;
    protected String status;
    protected String body;
    protected Map<String,String> responseHeaders;
    
    public HttpMockFactory(Integer code, String status, String body, Map<String,String> responseHeaders){
        this.code = code;
        this.status = status;
        this.body = body;
        this.responseHeaders = responseHeaders;
    }

    public HttpResponse respond(HttpRequest req){
        HttpResponse res = new HttpResponse();
        for(String key: responseHeaders.keySet()){
            res.setBody(this.body);
            res.setStatusCode(this.code);
            res.setStatus(this.status);
            return res;
        }
    }
}