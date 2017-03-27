global class UpdateProductionTeam {

    //@Future(callout=true)  
    @InvocableMethod
    public static void updateProductionTeam(List<Id> oppIdList){
        
         List<OpportunityTeamMember> listTeam =[SELECT CreatedById,CreatedDate,Id,IsDeleted,Name,OpportunityAccessLevel,
         OpportunityId,PhotoUrl,TeamMemberRole,Title,UserId FROM OpportunityTeamMember where id in : oppIdList];
         //afterInsert(listTeam);
     
    }
    
    
     
   
   
}