@IsTest
private class VNOS_DOMAIN_RecordType_Test {
  @IsTest
  static void developerName() {
    // Given
    Map<String, Object> recordTypeNode = new Map<String, Object>();
    recordTypeNode.put('DeveloperName', 'Promotion');
    VNOS_DOMAIN_RecordType recordType = new VNOS_DOMAIN_RecordType(
      recordTypeNode
    );

    // When
    String developerName = recordType.developerName();

    // Then
    System.assertEquals(
      'Promotion',
      developerName,
      'Developer name should match.'
    );
  }

  @IsTest
  static void id() {
    // Given
    Map<String, Object> recordTypeNode = new Map<String, Object>();
    recordTypeNode.put('Id', '1234567890');
    VNOS_DOMAIN_RecordType recordType = new VNOS_DOMAIN_RecordType(
      recordTypeNode
    );

    // When
    String id = recordType.id();

    // Then
    System.assertEquals('1234567890', id, 'ID should match.');
  }
}
