/**
* @author JhonCortes.org
* @version 1.0 01-02-2018 Jhon Cortes Class definition.
* @date 2018
* @group Calendar
* @group-content ../../ApexDocContent/CRAN_VAS_ON_Calendar_CLS.htm
* @description Class to expose webservice methods for Calendar service
*/
public without sharing class  CRAN_VAS_ON_Calendar_CLS extends CRAN_VAS_ON_GenericRest_WSC  implements CRAN_VAS_ON_IWSHandler_CLS {
    
    
    /** The CRAN_VAS_ON_ONBOARDING. */
    private static final String CRAN_VAS_ON_ONBOARDING = 'CRAN_VAS_ON_Onboarding';
   
    /** The FORMAT_DATE. */
    private static final String FORMAT_DATE  = 'dd/MM/yyyy HH:mm';

    /** The SUCCESS_MESSAGE. */
    public static final String SUCCESS_MESSAGE  = 'Operación Exitosa';
  
    /** The SUCCESS_MESSAGE. */
    public static final String CASE_ID_INVALID  = 'El valor del id del caso es inválido';
  
    /** The SUCCESS_MESSAGE. */
    public static final String DATE_INVALID  = 'El valor de la fecha del caso es inválida';
  
    /** The SUCCESS_MESSAGE. */
    public static final String STATUS  = 'status';

    /** The CASE. */
    public static final String CASE_OBJECT  = 'case';

    /** The obj case. */
    private Case objCase;      
  
    /**
     * Instantiates a new CRA N VA S O N calendar CLS.
     */
    public CRAN_VAS_ON_Calendar_CLS() {
    }  
     
    
    /**
     * Execute sub actions post.
     *
     * @param myParams
     *            the my params
     * @param strAction
     *            the str action
     * @param sp
     *            the sp
     * @return the response WS wrapper
     */
    public override  CRAN_VAS_ON_IResponseWSWrapper_CLS  executeSubActionsPost( final String params, final String strAction, final Integer responseCode  ){
                
        CRAN_VAS_ON_ResponseWSWrapper_CLS.CRAN_VAS_ON_ResponseWSWrapperCalendar_CLS  response =
                    new CRAN_VAS_ON_ResponseWSWrapper_CLS.CRAN_VAS_ON_ResponseWSWrapperCalendar_CLS();
        
        RequestWSWrapper myParams = (RequestWSWrapper) System.JSON.deserialize(params, RequestWSWrapper.class); 

        if(myParams.caseId == null){
                throw new CRAN_VAS_ON_Exception(CRAN_VAS_ON_ManageCalendar_CLS.ERROR_INTERNAL,CASE_ID_INVALID);
        }


        Set<String> stFields = new Set<String>{STATUS};   
        Case caseReturned = (Case)CRAN_VAS_ON_ManageCaseUtil_CLS.queryCase(myParams.caseId, stFields, null);
        CRAN_VAS_ON_ManageCalendar_CLS calendar = new CRAN_VAS_ON_ManageCalendar_CLS();
        Event eventReturned = calendar.insertCalendarEventDates(myParams.strDate,myParams.caseId,null);
        Map<Datetime,Set<String>> availablesDatesDataset = new Map<Datetime,Set<String>>();
        response = getResponseOK(availablesDatesDataset,caseReturned,eventReturned.Id,responseCode);
       
        return response;
    }
    
     /**
         * Execute sub actions get.
         *
         * @param myParams
         *            the my params
         * @param strAction
         *            the str action
         * @param sp
         *            the sp
         * @return the response WS wrapper
         */
      public override  CRAN_VAS_ON_IResponseWSWrapper_CLS  executeSubActionsGet( final String params, final String strAction, final Integer responseCode  ){
        
        CRAN_VAS_ON_ResponseWSWrapper_CLS.CRAN_VAS_ON_ResponseWSWrapperCalendar_CLS  response = new CRAN_VAS_ON_ResponseWSWrapper_CLS.CRAN_VAS_ON_ResponseWSWrapperCalendar_CLS();
        RequestWSWrapper myParams;
        myParams = (RequestWSWrapper) System.JSON.deserialize(params,RequestWSWrapper.class); 
        Set<String> stFields = new Set<String>{STATUS};   
        Case caseReturned = (Case)CRAN_VAS_ON_ManageObjectUtil_CLS.queryObject(myParams.caseId,CASE_OBJECT,stFields);
       
        CRAN_VAS_ON_ManageCalendar_CLS calendar = new CRAN_VAS_ON_ManageCalendar_CLS();
            
        DateTime incrementedDate = getOffsetZoneDateTime(System.now(),1);
        String formatedDtCurrent = incrementedDate.formatGMT(FORMAT_DATE);

        Map<Datetime,Set<String>> availablesDatesDataset = calendar.generateDates(formatedDtCurrent,true,null,true);
        response = getResponseOK(availablesDatesDataset,caseReturned,'',responseCode);
        return response;
    }
    
    
      /**
     * Execute sub actions put.
     *
     * @param myParams
     *            the my params
     * @param strAction
     *            the str action
     * @param sp
     *            the sp
     * @return the response WS wrapper
     */
    public override  CRAN_VAS_ON_IResponseWSWrapper_CLS  executeSubActionsPut( final String params, final String strAction , final Integer responseCode ){
                
        CRAN_VAS_ON_ResponseWSWrapper_CLS.CRAN_VAS_ON_ResponseWSWrapperCalendar_CLS  response = new CRAN_VAS_ON_ResponseWSWrapper_CLS.CRAN_VAS_ON_ResponseWSWrapperCalendar_CLS();
        RequestWSWrapper myParams;
        myParams = (RequestWSWrapper) System.JSON.deserialize(params,RequestWSWrapper.class); 
        Set<String> stFields = new Set<String>{STATUS};   
        List<Case> caseReturnedList = (List<Case>)CRAN_VAS_ON_ManageObjectUtil_CLS.queryObjectList(myParams.caseId,'Case',stFields);

        if(caseReturnedList.isEmpty()){
                throw new CRAN_VAS_ON_Exception(CRAN_VAS_ON_ManageCalendar_CLS.ERROR_INTERNAL,CRAN_VAS_ON_ManageCalendar_CLS.ERROR_CASE_EMPTY );
        }

        Case caseReturned = caseReturnedList.get(0);
        CRAN_VAS_ON_ManageCalendar_CLS calanedar = new CRAN_VAS_ON_ManageCalendar_CLS();
        Event eventReturned = calanedar.insertCalendarEventDates(myParams.strDate,myParams.caseId,myParams.eventId);
        Map<Datetime,Set<String>> availablesDatesDataset = new Map<Datetime,Set<String>>();
        response = getResponseOK(availablesDatesDataset,caseReturned,eventReturned.Id,responseCode);
      
        return response;
    }
    
    
    
     /**
     * Execute sub actions put.
     *
     * @param myParams
     *            the my params
     * @param strAction
     *            the str action
     * @param sp
     *            the sp
     * @return the response WS wrapper
     */
    public override  CRAN_VAS_ON_IResponseWSWrapper_CLS  executeSubActionsDelete( final String params,final  String strAction, final Integer responseCode  ){
                
        CRAN_VAS_ON_ResponseWSWrapper_CLS.CRAN_VAS_ON_ResponseWSWrapperCalendar_CLS  response = new CRAN_VAS_ON_ResponseWSWrapper_CLS.CRAN_VAS_ON_ResponseWSWrapperCalendar_CLS();
        RequestWSWrapper myParams;

        myParams = (RequestWSWrapper) System.JSON.deserialize(params,RequestWSWrapper.class); 
        
        CRAN_VAS_ON_ManageCalendar_CLS calendar = new CRAN_VAS_ON_ManageCalendar_CLS();
        Case caseReturned = calendar.deleteCalendarEventDates(myParams.eventId,myParams.caseId);
        Map<Datetime,Set<String>> availablesDatesDataset = new Map<Datetime,Set<String>>();
        response = getResponseOK(availablesDatesDataset,caseReturned,myParams.eventId,responseCode);
        return response;   
    }
    
    /**
     * Gets the response OK.
     *
     * @param availablesDatesDataset
     *            the availables dates dataset
     * @param objCase
     *            the obj case
     * @return the response OK
     */
    public CRAN_VAS_ON_ResponseWSWrapper_CLS.CRAN_VAS_ON_ResponseWSWrapperCalendar_CLS  getResponseOK(final  Map<Datetime,Set<String>> availablesDatesDataset,
                                                                                        final Case objCase,final String eventId, final Integer responseCode ) {
        
        CRAN_VAS_ON_ResponseWSWrapper_CLS.CRAN_VAS_ON_ResponseWSWrapperCalendar_CLS  response = new CRAN_VAS_ON_ResponseWSWrapper_CLS.CRAN_VAS_ON_ResponseWSWrapperCalendar_CLS();
        response.validated = true;
        response.error = false;
        response.message = SUCCESS_MESSAGE;
        response.eventId = eventId ; 
        response.caseId = objCase.Id; 
        response.prevStatus = CRAN_VAS_ON_ManageCaseUtil_CLS.getMapStages(objCase.Id).CRAN_VAS_ON_P_Prev_Status__c;
        response.currentStatus= objCase.status;  
        response.nextStatus = CRAN_VAS_ON_ManageCaseUtil_CLS.getMapStages(objCase.Id).CRAN_VAS_ON_P_Next_Status__c;
        
        if(!availablesDatesDataset.IsEmpty()){
            List<Datetime> dateList = new List<Datetime>();
            for(Datetime dateSlot : availablesDatesDataset.keySet()){
                dateList.add(dateSlot);
            }
            response.dateList = dateList; 
        }        
        return response;
    } 
    
    
    /**
     * Gets the offset zone date time based on 1000 localtime conmutator.
     *
     * @param dateTimeInput
     *            the date time input
     * @param conmutator
     *            the conmutator it would be 1 or -1
     * @return the offset zone date time
     */
    public Datetime getOffsetZoneDateTime(Datetime dateTimeInput, Integer conmutator){
        TimeZone timeZone = UserInfo.getTimeZone();
        DateTime localTime = dateTimeInput;
        return localTime.AddSeconds(timeZone.getOffset(localTime)/1000 * conmutator);
    }
    
  

    /**
     * The Class RequestWSWrapper used to create event response for service.
     */
    public class RequestWSWrapper {
        
        /** The str date. */
        private String strDate;
        
        /** The case id. */
        private String caseId;  
        
         /** The event id. */
        private String eventId;  


        /** The str date. */
        public String getStrDate() {
            return strDate;
        }
        
        /** The str date. */
        public void setStrDate(String strDate) {
            this.strDate = strDate;
        }

        /** The case id. */
        public String getCaseId() {
            return caseId;
        }
        
        /** The case id. */
        public void setCaseId(String caseId) {
            this.caseId = caseId;
        }

         /** The event id. */
        public String getEventId() {
            return eventId;
        }
        
         /** The event id. */
        public void setEventId(String eventId) {
            this.eventId = eventId;
        }


    }
    
   
}