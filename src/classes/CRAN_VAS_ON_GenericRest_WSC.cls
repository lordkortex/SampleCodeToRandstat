/**
* @author JhonCortes.org
* @version 1.0 01-02-2018 Jhon Cortes Class definition.
* @date 2018
* @group Calendar
* @group-content ../../ApexDocContent/CRAN_VAS_ON_GenericRest_WSC.htm
* @description Class to expose webservice methods for generic purpose
*/
public abstract class CRAN_VAS_ON_GenericRest_WSC implements CRAN_VAS_ON_IWSHandler_CLS{
   
   /** The Constant METHOD_POST . */
   private static final String METHOD_POST = 'POST';
   
    /** The Constant METHOD_PUT . */
   private static final String METHOD_PUT = 'PUT';
   
   /** The Constant METHOD_DELETE . */
   private static final String METHOD_DELETE = 'DELETE';
   
   /** The Constant METHOD_GET . */
   private static final String METHOD_GET = 'GET';
   
   
    /**
    * Execute action post method.
    *
    * @param params
    *            the params
    * @param strAction
    *            the str action
    * @param responseCode
    *            the response Code
    * @return the string
    */
    public String executeActionMethod( final String params, final String strAction,final  String method, final Integer responseCode ) {   
        
        //Savepoint sp = Database.setSavepoint();
        String jsonResponse;
        
        if(method == METHOD_POST){
                CRAN_VAS_ON_IResponseWSWrapper_CLS response =  executeSubActionsPost( params, strAction, responseCode );
       			jsonResponse = System.JSON.serialize(response); 
        }
        if(method == METHOD_PUT){
                CRAN_VAS_ON_IResponseWSWrapper_CLS response =  executeSubActionsPut( params, strAction, responseCode  );
       			jsonResponse = System.JSON.serialize(response); 
        }
        if(method == METHOD_DELETE){
                CRAN_VAS_ON_IResponseWSWrapper_CLS response =  executeSubActionsDelete( params, strAction, responseCode  );
       			jsonResponse = System.JSON.serialize(response); 
        }  
        if(method == METHOD_GET ){
                CRAN_VAS_ON_IResponseWSWrapper_CLS response =  executeSubActionsGet( params, strAction, responseCode  );
       			jsonResponse = System.JSON.serialize(response); 
        }
                  
        return jsonResponse; 
    }
    
    
    /**
    * Execute action post method.
    *
    * @param params
    *            the params
    * @param strAction
    *            the str action
    * @param responseCode
    *            the response Code
    * @return the string
    */
    public String executeActionPostMethod( final String params, final String strAction, final Integer responseCode ) {   
        return executeActionMethod(params,strAction ,METHOD_POST,responseCode); 
    }
    
    /**
    * Execute action get method.
    *
    * @param params
    *            the params
    * @param strAction
    *            the str action
    * @param responseCode
    *            the response Code
    * @return the string
    */
    public String executeActionGetMethod(final  String params, final String strAction, final Integer responseCode)  {   
       return executeActionMethod(params,strAction ,METHOD_GET,responseCode);
     }
    
    
    /**
    * Execute action put method.
    *
    * @param params
    *            the params
    * @param strAction
    *            the str action
    * @param responseCode
    *            the response Code
    * @return the string
    */
    public String executeActionPutMethod( final String params, final String strAction , final Integer responseCode) {   
       return executeActionMethod(params,strAction ,METHOD_PUT, responseCode);
     }
    
    
    /**
    * Execute action delete method.
    *
    * @param params
    *            the params
    * @param strAction
    *            the str action
    * @param responseCode
    *            the response Code
    * @return the string
    */
    public String executeActionDeleteMethod( final String params, final String strAction , final Integer responseCode) {   
       return executeActionMethod(params,strAction ,METHOD_DELETE, responseCode);
     }

   
    /**
     * Execute sub actions post.
     *
     * @param params
     *            the params
     * @param strAction
     *            the str action
     * @param responseCode
     *            success code
     * @return the CRAN_VAS_ON_ResponseWSWrapper  response WS wrapper
     */
    public abstract CRAN_VAS_ON_IResponseWSWrapper_CLS  executeSubActionsPost( final String params, final String strAction, final Integer responseCode);
     
    /**
     * Execute sub actions get.
     *
     * @param params
     *            the params
     * @param strAction
     *            the str action
     * @param responseCode
     *            the response Code
     * @return the CRAN_VAS_ON_ResponseWSWrapper  response WS wrapper
     */
    public abstract  CRAN_VAS_ON_IResponseWSWrapper_CLS executeSubActionsGet( final String params, final String strAction, final Integer responseCode);
     
    /**
     * Execute sub actions post.
     *
     * @param params
     *            the params
     * @param strAction
     *            the str action
     * @param responseCode
     *            the response Code
     * @return the CRAN_VAS_ON_ResponseWSWrapper  response WS wrapper
     */
    public abstract CRAN_VAS_ON_IResponseWSWrapper_CLS executeSubActionsPut( final String params, final String strAction, final Integer responseCode);
    
    /**
     * Execute sub actions post.
     *
     * @param params
     *            the params
     * @param strAction
     *            the str action
     * @param responseCode
     *            the response Code
     * @return the CRAN_VAS_ON_ResponseWSWrapper  response WS wrapper
     */
    public abstract CRAN_VAS_ON_IResponseWSWrapper_CLS executeSubActionsDelete( final String params, final String strAction, Integer final responseCode);
    
    
    
}