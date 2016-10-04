@isTest
public class DocumentServiceTest {

	private static testMethod void testGetTemplate() {
		String bodyText = 'test body';
		String developerName = 'testDocument';
		Folder f = [SELECT id FROM Folder WHERE developerName = 'Templates' LIMIT 1];
		insert new Document(name = developerName, developerName = developerName, folderId = f.id, body = Blob.valueof(bodyText));
		String res = DocumentService.getTemplate(developerName);
		System.assertEquals(res, bodyText);
	}

}
