/**
* @author JhonCortes.org
* @version 1.0 01-02-2018 Jhon Cortes Class definition.
* @date 2018
* @group Calendar
* @group-content ../../ApexDocContent/CRAN_VAS_ON_IWSHandler_CLS.htm
* @description Class Interface to expose webservice methods for general purpose
*/

public interface CRAN_VAS_ON_IWSHandler_CLS {
    
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
    String executeActionPostMethod( final String params, final String strAction, final Integer responseCode );  
    
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
    String executeActionGetMethod(final  String params,final  String strAction, final Integer responseCode );  
    
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
    String executeActionPutMethod( final String params,final  String strAction, final Integer responseCode );  
     
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
    String executeActionDeleteMethod( final String params,final  String strAction,final  Integer responseCode );  
}