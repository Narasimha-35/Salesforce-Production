/*====================================================
				Click Loans
========================================================*/
Public class acfViewPdf {
    Public string strDocumentId {get;set;}
    Public acfViewPdf(){
        List<Document> lstDoc = new List<Document>();
        string pge = Apexpages.currentPage().getUrl();
        List<String> parts = pge.split('/'); 
        List<String> parts1 = parts[2].split('\\?');
        String pge_name = parts1[0];
        system.debug('pgName@@@'+pge_name);
            lstDoc = [select id,name,body,contentType from document where name=:pge_name limit 1];
            If(lstDoc != null && lstDoc.size()>0){
                strDocumentId = lstDoc[0].Id;
            }   
    }
}