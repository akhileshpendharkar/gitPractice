@isTest
public class GoogleSearchTest {
    
    @isTest
    static void testGoogle(){
        HttpMockFactory mock = new HttpMockFactory(200,'Complete','google.com',null);
        //Test.setMock(interfaceType, mock);
        Test.setMock(HttpCalloutMock.class, mock);
        String result = GoogleSearch.googleMe('cricket');
        System.Assert.areEqual('google.com', result);
    }

}