public class DocumentService {

    public static String getTemplate(String developerName) {
        Document doc = [SELECT id, body FROM Document WHERE developerName =: developerName LIMIT 1];
        return doc.body.toString();
    }

}