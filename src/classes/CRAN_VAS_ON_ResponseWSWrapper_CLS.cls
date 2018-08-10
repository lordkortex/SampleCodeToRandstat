/**
* @author JhonCortes.org
* @version 1.0 01-02-2018 Jhon Cortes Class definition.
* @date 2018
* @group Calendar
* @group-content ../../ApexDocContent/CRAN_VAS_ON_ResponseWSWrapper_CLS.htm
* @description Class wrapper for Calendar service responses
*/
public virtual class CRAN_VAS_ON_ResponseWSWrapper_CLS implements CRAN_VAS_ON_IResponseWSWrapper_CLS {
        
        /** The case id. */
        private String caseId; 
        
        /** The validated. */
        private Boolean  validated;
        
        /** The error. */
        private Boolean error;
        
        /** The message. */
        private String message;

        /** The next status. */
        private String prevStatus;

        /** The current status. */
        private String currentStatus;

        /** The next status. */
        private String nextStatus;

        
        /** The case id. */
        public String getCaseId() {
            return caseId;
        }
        
        /** The case id. */
        public void setCaseId(String caseId) {
            this.caseId = caseId;
        }


        /** The validated. */
        public Boolean getValidated() {
            return validated;
        }
        
        /** The validated. */
       public void setValidated(Boolean validated) {
            this.validated = validated;
        }


        /** The error. */
        public Boolean getError() {
            return error;
        }
        
        /** The error. */
        public void setError(Boolean error) {
            this.error = error;
        }


        /** The message. */
        public String getMessage() {
            return message;
        }
        
        /** The message. */
        public void setMessage(String message) {
            this.message = message;
        }

        /** The next status. */
        public String getPrevStatus() {
            return prevStatus;
        }
        
        /** The next status. */
        public void setPrevStatus(String prevStatus) {
            this.prevStatus = prevStatus;
        }

        /** The current status. */
        public String getCurrentStatus() {
            return currentStatus;
        }
        
        /** The current status. */
        public void setCurrentStatus(String currentStatus) {
            this.currentStatus = currentStatus;
        }

        /** The next status. */
        public String getNextStatus() {
            return nextStatus;
        }
        
        /** The next status. */
        public void setNextStatus(String nextStatus) {
            this.nextStatus = nextStatus;
        }

    
}