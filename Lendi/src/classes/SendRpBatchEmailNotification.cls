public class SendRpBatchEmailNotification{

public static Messaging.SingleEmailMessage sendEmailNotification(String Content , Id ID){
list<string> lstToaddress = new list<string>();
            string strEmail = '';
            if(System.label.acf_Bank_Statement_Response_Error_Email != null && System.label.acf_Bank_Statement_Response_Error_Email !='')
                strEmail = System.label.acf_Bank_Statement_Response_Error_Email;
            if(strEmail != null && strEmail != '')  
            {
                string[] strToaddress = strEmail.split(';');
                for(string strObjEmail : strToaddress)
                {
                    lstToaddress.add(strObjEmail);
                }
            }
            if(!lstToaddress.isEmpty())
            {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                string strSubject = 'RpData Api Issue';
                string strContent = Content   + 'for Id: '+ ID;
                email.setToAddresses(lstToaddress);   
                email.setSubject(strSubject);
                email.setSenderDisplayName('ACF Support');
                email.setPlainTextBody(strContent);
                
                return email;
               
            }
            else
            {
            return null;
            }
}

}