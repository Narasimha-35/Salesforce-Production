global class MercuryController
{
    webservice static String synkMercury( Id oppoId   ) 
    { 
            OpportunitySelector oppoSelector = new OpportunitySelector();
            Opportunity oppo = oppoSelector.getById(oppoId);
            MercuryService.updateApplication(oppo );
            if(oppo.mercury_error__C  != NULL ||  oppo.mercury_error__C  != null  )
            {
                if(!oppo.mercury_error__C.contains('Error'))
                {
                    return 'Mercury sync successful.Loan updated';
                }
                else
                {
                 return oppo.mercury_error__C ;
                }
            
            }
            else
            {
             return   'Mercury sync successful.Loan - updated';
            }
           
    }
}